import { AppUpdateUtil } from '@leo2/smart_utils'

@Entry
@Component
export struct UpdatePage {
  build() {
    NavDestination() {
      Column() {
        Button('点击检查更新', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({ top: '30lpx' })
          .onClick(() => {
            AppUpdateUtil.checkAppUpdate()
          })
      }
      .height('100%')
      .width('100%')
    }
    .title('检查更新')
  }
}