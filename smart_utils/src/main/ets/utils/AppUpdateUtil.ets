import { common } from '@kit.AbilityKit';
import { updateManager } from '@kit.StoreKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

export class AppUpdateUtil {
  private constructor() {

  }


  public static checkAppUpdate(showLoading?: () => void, hideLoading?: () => void) {
    if (showLoading != undefined) {
      showLoading()
    }

    let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
    updateManager.checkAppUpdate(context)
      .then((checkResult: updateManager.CheckUpdateResult) => {
        //0 没有更新  1 有新版本
        if (checkResult.updateAvailable == 0) {
          AppUpdateUtil.showToast("已是最新版本")
        } else {
          AppUpdateUtil.showUpdateDialog()
        }
        console.debug("检查更新", "Succeeded in checking Result updateAvailable:" + checkResult.updateAvailable);
      }).catch((error: BusinessError) => {
      AppUpdateUtil.showToast(error.message)
      console.debug("检查更新", `checkAppUpdate onError.code is ${error.code}, message is ${error.message}`);
    }).finally(() => {
      if (hideLoading != undefined) {
        hideLoading()
      }
    })

  }

  public static showUpdateDialog() {
    //应用市场更新
    //https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/store-update-V5
    let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
    updateManager.showUpdateDialog(context)
      .then((resultCode: updateManager.ShowUpdateResultCode) => {
        console.debug("检查更新", "Succeeded in showing UpdateDialog resultCode:" + resultCode);
      })
      .catch((error: BusinessError) => {
        console.debug("检查更新", `showUpdateDialog onError.code is ${error.code}, message is ${error.message}`);
      });
  }

  private static showToast(message: string | Resource) {
    if ((typeof message === 'string' && message.length > 0) || message) {
      promptAction.showToast({
        message: message,
        duration: 1500,
        bottom: '80vp',
        showMode: promptAction.ToastShowMode.DEFAULT,
        alignment: Alignment.Center,
        // offset: options?.offset
      })
    }
  }
}