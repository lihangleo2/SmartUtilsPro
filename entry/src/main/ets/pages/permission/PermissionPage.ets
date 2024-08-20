import { SmartPermissionUtil } from '@leo2/smart_utils'
import { ToastUtil } from '@pura/harmony-utils'

@Entry
@Component
export struct PermissionPage {
  build() {
    NavDestination() {
      Column() {
        /*
         * 权限请求实例代码
         * */
        Button('点击申请相机权限', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({ top: '30lpx' })
          .onClick(() => {
            SmartPermissionUtil.requestPermissions('ohos.permission.CAMERA')
              .subscribe(() => {
                //全部权限请求成功回调
                ToastUtil.showToast("权限请求成功~")
              }, (noAgreePermissions, isDenied) => {

                if (isDenied) {
                  ToastUtil.showToast("已被拒绝权限，请打开弹窗提示及系统设置")
                } else {
                  ToastUtil.showToast("请打开相关权限")
                }
              })
          })
      }
      .height('100%')
      .width('100%')
    }
    .title('权限申请')
  }
}