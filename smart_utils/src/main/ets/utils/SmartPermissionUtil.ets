import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';

/*
 * 使用案例
     MyPermissionUtil.requestPermissions('ohos.permission.CAMERA', 'ohos.permission.MICROPHONE')//参数支持一直往后加
      .subscribe(() => {
        //全部权限请求成功回调

      }, (noAgreePermissions,isDenied) => {

        if (isDenied) {
          MyXPopupUtil.showPop(this.mXpop!!)
        }else {
          ToastUtil.showToast("请打开相关权限")
        }

      })

  * onFail参数说明
    //noAgreePermissions:Array<Permissions> 被拒绝的权限
    //isDenied：false -> 有系统权限弹窗；属于第一次申请，拒绝某权限时回调
    //          true -> 没有系统权限弹窗；第二次申请（第一次拒绝了权限），弹权限设置pop,去手机设置
    *
 * */


export class SmartPermissionUtil {
  private mPermissions: Array<Permissions> = [];

  private constructor() {

  }

  static requestPermissions(...names: Array<Permissions>): SmartPermissionUtil {
    if (names == undefined || names.length == 0) {
      throw new Error('MyPermissionUtil ==> 申请权限不可为空')
    }
    let permission = new SmartPermissionUtil()
    permission.mPermissions = names
    return permission
  }

  //onSuccess：权限全部请求成功回调
  //onFail：有权限被拒绝
  //-- permissionName：被拒绝的全新啊
  //-- isDenied：true-被系统拒绝，属于二次申请,一般弹权限设置弹窗。  false-属于第一申请被拒，一般弹toast
  subscribe(onSuccess: () => void, onFail?: (noAgreePermissions: Array<Permissions>, isDenied: boolean) => void) {

    abilityAccessCtrl.createAtManager().requestPermissionsFromUser(getContext(), this.mPermissions).then((data) => {
      let permissionNames = data.permissions
      let array = data.authResults
      let diaResults = data.dialogShownResults
      let noAgreePermissions = new Array<Permissions>()
      let allDenied = true

      diaResults?.forEach((shown) => {
        if (shown) {
          allDenied = false
        }
      })

      //
      array.forEach((authNumber, index) => {
        if (authNumber == abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
          noAgreePermissions.push(permissionNames[index] as Permissions)
        }
      })

      //因系统框架问题，有系统权限弹窗，在系统弹窗消失时，第一时间去toast,不会显示
      setTimeout(()=>{

        if (noAgreePermissions.length == 0) {
          onSuccess()
        } else {
          if (onFail != undefined) {
            onFail(noAgreePermissions, allDenied)
          }
        }

      },10)
    })
  }
}