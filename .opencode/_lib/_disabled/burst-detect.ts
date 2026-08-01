// exports: checkBurst, BurstState, defaultState, SLIDING_WINDOW_MS, BURST_THRESHOLD, COOLDOWN_MS
// purity: pure
// depends-on: none

export const SLIDING_WINDOW_MS = 2000
export const BURST_THRESHOLD = 5
export const COOLDOWN_MS = 5000

export interface BurstState {
  fileEvents: Array<{ file: string; time: number }>
  lastAlertTime: number
  alertCount: number
}

export function defaultState(): BurstState {
  return { fileEvents: [], lastAlertTime: 0, alertCount: 0 }
}

export function checkBurst(state: BurstState, file: string): BurstState {
  const now = Date.now()
  const events = [...state.fileEvents, { file, time: now }]
  const cutoff = now - SLIDING_WINDOW_MS
  const pruned = events.filter(e => e.time >= cutoff)
  const unique = new Set(pruned.map(e => e.file))
  if (unique.size >= BURST_THRESHOLD && now - state.lastAlertTime >= COOLDOWN_MS) {
    return { fileEvents: pruned, lastAlertTime: now, alertCount: state.alertCount + 1 }
  }
  return { fileEvents: pruned, lastAlertTime: state.lastAlertTime, alertCount: state.alertCount }
}
