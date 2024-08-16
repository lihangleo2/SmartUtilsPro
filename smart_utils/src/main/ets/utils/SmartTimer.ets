export class SmartTimer {
  intervalTime: number
  totalTime: number
  timerId: number | null = null
  onTimerTick: onTimerTick | null  = null
  onFinish: onFinish | null | undefined = null
  realTotalTime: number
  isRunning: boolean = false

  constructor(intervalTime: number, totalTime: number) {
    this.intervalTime = intervalTime
    this.totalTime = totalTime
    this.realTotalTime = totalTime
  }

  setListener(onTimerTick: (elapsedTime: number) => void, onFinish?: () => void): SmartTimer{
    this.onTimerTick = onTimerTick
    this.onFinish = onFinish
    return this
  }

  start() {
    this.isRunning = true
    this.timerId = setInterval(() => {
      this.totalTime -= this.intervalTime
      if (this.onTimerTick != null && this.totalTime >= 0) {
        this.onTimerTick(this.totalTime)
      }
      if (this.totalTime <= 0) {
        if (this.onFinish != null) {
          this.onFinish()
        }
        this.isRunning = false
        this.totalTime = this.realTotalTime
        this.pause()
      }
    }, this.intervalTime)
  }

  pause() {
    clearInterval(this.timerId)
    this.isRunning = false
  }

  resume() {
    this.start()
  }

  stop() {
    this.pause()
    this.totalTime = this.realTotalTime
    this.isRunning = false
  }
}

export type onTimerTick = (elapsedTime: number) => void;

export type onFinish = () => void;

