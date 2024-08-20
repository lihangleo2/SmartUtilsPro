import { SmartTimer } from '@leo2/smart_utils'

@Entry
@Component
export struct TimerPage {
  @State codeMessage: string = '获取验证码';
  codeTimer: SmartTimer = new SmartTimer(1000, 60000)

  aboutToAppear(): void {
    this.codeTimer.setListener((elapseTime) => {
      this.codeMessage = `重新获取${elapseTime / 1000}s`
    }, () => {
      this.codeMessage = '获取验证码'
    })
  }

  build() {
    NavDestination() {
      Column() {
        Text(this.codeMessage)
          .id('textGetCode')
          .fontSize('14lpx')
          .fontColor("#4F7AF2")
          .margin({ top: '30lpx' })
          .onClick(() => {
            this.getSmsCode()
          })

        Button('开始计时器', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({top:'15lpx'})
          .onClick(() => {
            this.getSmsCode()
          })

        Button('暂停计时器', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({top:'15lpx'})
          .onClick(() => {
            this.codeTimer.pause()
          })

        Button('恢复计算器', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({top:'15lpx'})
          .onClick(() => {
            this.codeTimer.resume()
          })
      }
      .height('100%')
      .width('100%')
    }
    .title('计时器')
  }

  getSmsCode() {
    if (this.codeMessage != '获取验证码') {
      return
    }
    this.codeTimer.start()
  }
}