/*
 * 使用案例
 * 1.new一个Timer出来。
 * 参数1：表示每隔多少毫秒响应一次
 * 参数2：表示总共经历多少时间totalTime。达到totalTime后，计时器停止
   codeTimer: SmartTimer = new SmartTimer(1000, 60000)

 * 2.设置监听
 * 回调1：还剩下的时间，总时间减去已经响应过的时间
 * 回调2：达到totalTime停止后，计时器停止回调onFinish
   this.codeTimer.setListener((elapseTime) => {
      this.codeMessage = `重新获取${elapseTime / 1000}s`
   }, () => {
      this.codeMessage = '获取验证码'
   })

 * 3.开始计时
   this.codeTimer.star()

 * 4.暂停计时
   this.codeTimer.pause()

 * 5.恢复计时
   this.codeTimer.resume()

 * 6.取消计时
   this.codeTimer.cancle()
 * */


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
    if (this.isRunning==true){
      return
    }
    this.isRunning = true
    //解决第一时间响应
    if (this.onTimerTick != null && this.totalTime >= 0) {
      this.onTimerTick(this.totalTime)
    }
    //
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

  cancle() {
    this.pause()
    this.totalTime = this.realTotalTime
  }
}

export type onTimerTick = (elapsedTime: number) => void;

export type onFinish = () => void;

