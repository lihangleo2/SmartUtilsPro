import { ActivityUtil } from '@leo2/smart_utils'
import { AppRouter } from '../common/AppRouter'

@Entry
@Component
export struct MainPage {
  build() {
    NavDestination() {
      Column() {
        /*
         * 跳转权限申请页
         * */
        Button('申请权限', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({ top: '30lpx' })
          .onClick(() => {
            ActivityUtil.startActivity({
              name: AppRouter.activity_permission
            })
          })

        /*
         * 跳转计时器页
         * */
        Button('计时器使用', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({ top: '30lpx' })
          .onClick(() => {
            ActivityUtil.startActivity({
              name: AppRouter.activity_timer
            })
          })

        /*
         * 跳转检查更新
         * */
        Button('检查更新', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({ top: '30lpx' })
          .onClick(() => {
            ActivityUtil.startActivity({
              name: AppRouter.activity_update
            })
          })

      }
      .height('100%')
      .width('100%')
    }
    .hideTitleBar(true)
    .onBackPressed(() => {
      return true
    })
  }
}