// ann.go — ANN worker for _templates semantic engine.
// Binary transport over stdin/stdout — one batch per invocation, goroutine-parallel scoring.
//
// Protocol (little-endian f32, no JSON in the hot path):
//   stdin:  4-byte uint32 nq | 4-byte uint32 nv | 4-byte uint32 dim | 4-byte uint32 k
//           | nq*dim f32 query vectors | nv*dim f32 pool vectors
//   stdout: for each query (in order): 4-byte uint32 k | k*(4-byte uint32 idx + 4-byte f32 score)
//
// Usage: ann < payload.bin > out.bin
package main

import (
	"encoding/binary"
	"io"
	"math"
	"os"
	"sort"
	"sync"
)

type hit struct {
	index uint32
	score float32
}

// score computes cosine similarity between two vectors.
func score(a, b []float32) float32 {
	var dot, la, ra float64
	n := len(a)
	if len(b) < n {
		n = len(b)
	}
	for i := 0; i < n; i++ {
		dot += float64(a[i]) * float64(b[i])
		la += float64(a[i]) * float64(a[i])
		ra += float64(b[i]) * float64(b[i])
	}
	norm := math.Sqrt(la * ra)
	if norm == 0 {
		return 0
	}
	return float32(dot / norm)
}

// unit returns the L2-normalized copy of v.
func unit(v []float32) []float32 {
	var sum float64
	for _, x := range v {
		sum += float64(x) * float64(x)
	}
	length := math.Sqrt(sum)
	if length == 0 {
		return append([]float32(nil), v...)
	}
	out := make([]float32, len(v))
	for i, x := range v {
		out[i] = float32(float64(x) / length)
	}
	return out
}

// topk returns the k highest-scoring hits for query against pool.
func topk(query []float32, pool [][]float32, k int) []hit {
	q := unit(query)
	hits := make([]hit, len(pool))
	for i, v := range pool {
		hits[i] = hit{index: uint32(i), score: score(q, v)}
	}
	sort.Slice(hits, func(a, b int) bool { return hits[a].score > hits[b].score })
	if len(hits) > k {
		hits = hits[:k]
	}
	return hits
}

func main() {
	// Read header
	var hdr [4]uint32
	if err := binary.Read(os.Stdin, binary.LittleEndian, &hdr); err != nil {
		os.Exit(1)
	}
	nq, nv, dim, k := hdr[0], hdr[1], hdr[2], hdr[3]

	// Read queries
	qbuf := make([]byte, nq*dim*4)
	if _, err := io.ReadFull(os.Stdin, qbuf); err != nil {
		os.Exit(1)
	}
	queries := make([][]float32, nq)
	for i := uint32(0); i < nq; i++ {
		queries[i] = make([]float32, dim)
		for j := uint32(0); j < dim; j++ {
			off := (i*dim + j) * 4
			queries[i][j] = math.Float32frombits(binary.LittleEndian.Uint32(qbuf[off : off+4]))
		}
	}

	// Read pool
	pbuf := make([]byte, nv*dim*4)
	if _, err := io.ReadFull(os.Stdin, pbuf); err != nil {
		os.Exit(1)
	}
	pool := make([][]float32, nv)
	for i := uint32(0); i < nv; i++ {
		pool[i] = make([]float32, dim)
		for j := uint32(0); j < dim; j++ {
			off := (i*dim + j) * 4
			pool[i][j] = math.Float32frombits(binary.LittleEndian.Uint32(pbuf[off : off+4]))
		}
	}

	// Score all queries in parallel — goroutines over query index
	results := make([][]hit, nq)
	var wg sync.WaitGroup
	sem := make(chan struct{}, 8) // bound concurrency
	for i := uint32(0); i < nq; i++ {
		wg.Add(1)
		sem <- struct{}{}
		go func(i uint32) {
			defer wg.Done()
			defer func() { <-sem }()
			results[i] = topk(queries[i], pool, int(k))
		}(i)
	}
	wg.Wait()

	// Write results — per query: uint32 k, then k*(idx, score)
	out := make([]byte, 0, nq*(4+uint32(k)*8))
	tmp := make([]byte, 4)
	for _, hits := range results {
		binary.LittleEndian.PutUint32(tmp, uint32(len(hits)))
		out = append(out, tmp...)
		for _, h := range hits {
			binary.LittleEndian.PutUint32(tmp, h.index)
			out = append(out, tmp...)
			binary.LittleEndian.PutUint32(tmp, math.Float32bits(h.score))
			out = append(out, tmp...)
		}
	}
	os.Stdout.Write(out)
}
