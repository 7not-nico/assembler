# Channel types — concurrent communication

```
Source: Go Spec §Channel types
URL:    https://go.dev/ref/spec#Channel_types
```

A channel provides a mechanism for concurrently executing functions to communicate by sending and receiving values of a specified element type. The value of an uninitialized channel is nil.

```
ChannelType = ( "chan" | "chan" "<-" | "<-" "chan" ) ElementType .
```

The optional `<-` operator specifies the channel direction, send or receive. If a direction is given, the channel is directional, otherwise it is bidirectional.

```
chan T          // can be used to send and receive values of type T
chan<- float64  // can only be used to send float64s
<-chan int      // can only be used to receive ints
```

A new, initialized channel value can be made using the built-in function `make`, which takes the channel type and an optional capacity as arguments:

```
make(chan int, 100)
```

The capacity, in number of elements, sets the size of the buffer in the channel. If the capacity is zero or absent, the channel is unbuffered and communication succeeds only when both a sender and receiver are ready. Otherwise, the channel is buffered and communication succeeds without blocking if the buffer is not full (sends) or not empty (receives). A nil channel is never ready for communication.

A channel may be closed with the built-in function `close`.

```
Source: Go Spec §Select statements
URL:    https://go.dev/ref/spec#Select_statements
```

A "select" statement chooses which of a set of possible send or receive operations will proceed.
