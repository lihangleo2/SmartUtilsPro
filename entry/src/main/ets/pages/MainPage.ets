import { SmartPermissionUtil } from '@leo2/smart_utils'
import { ToastUtil } from '@pura/harmony-utils'
import { AppRouter } from '../common/AppRouter'
import { ActivityUtil } from '../util/ActivityUtil'

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
            ActivityUtil.startActivity(AppRouter.activity_permission)
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
            ActivityUtil.startActivity(AppRouter.activity_timer)
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