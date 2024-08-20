/*
 * 初始化，找到入口文件
 struct Index {
  @Provide app: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    ActivityUtil.init(this.app)
    //...伪代码
  }
}

 *
 * 简单跳转
   ActivityUtil.startActivity("Login")
 *
 * 带参数跳转
   ActivityUtil.startActivity("WebViewPage",1)
 *
 * 监听上一个页面回调监听
   ActivityUtil.startActivity("WordsPage",item,(popInfo)=>{
      console.debug("页面回调", 'Pop page name is: ' + popInfo.info.name + ', result: ' + JSON.stringify(popInfo.result))
   })

   *
   * 关闭页面
   ActivityUtil.finish()
   *
   * 关闭页面，并传值
   ActivityUtil.finish("数据")
   *
   *关闭栈内存在的页面：参数支持一直逗号下去如：ActivityUtil.finishByName("SplashPage","其他页面","其他页面")
   ActivityUtil.finishByName("SplashPage")
   *
   * 关闭页面，并跳转到指定页面，（如果"Login"在栈内存在，则关闭页面并跳转。如果不存在，则关闭页面并新建Login后跳转）
   ActivityUtil.finishAndStartActivity("Login")
   *
   * 关闭页面，并跳转到指定页面并传值
   ActivityUtil.finishAndStartActivity("Login","数据")
   *
   * 关闭栈内所有页面，最新的页面除外
   ActivityUtil.finishAllPagesExceptNewest()
   *
   * 关闭栈内所有页面，除了参数内的页面:：参数支持一直逗号下去如：ActivityUtil.finishAllPagesExcept("HomePage","其他页面","其他页面")
   ActivityUtil.finishAllPagesExcept("HomePage")
   *
   * 系统的replace方法，替换页面
   ActivityUtil.replacePathByName("SplashPage")
 * */
import { On } from '@ohos.UiTest'
import { common, Want } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'


export class ActivityUtil {
  private app?: NavPathStack
  private static instance: ActivityUtil

  private constructor() {

  }

  public static init(app: NavPathStack) {
    if (!ActivityUtil.instance) {
      ActivityUtil.instance = new ActivityUtil()
    }
    if (ActivityUtil.instance.app != undefined) {
      throw new Error('ActivityUtil ==> 不可重复初始化NavPathStack')
    }
    ActivityUtil.instance.app = app
  }

  private static getInstance(): ActivityUtil {
    if (!ActivityUtil.instance || ActivityUtil.instance.app == undefined) {
      throw new Error('ActivityUtil ==> 未初始化NavPathStack，入口文件需初始化ActivityUtil.init(NavPathStack)')
    }
    return ActivityUtil.instance
  }

  public static startActivity(name: string, param?: Object | null, onPop?: (popInfo: PopInfo) => void,
    animated?: boolean) {
    if (onPop == undefined) {
      ActivityUtil.getInstance().app?.pushPathByName(name, param, animated)
    } else {
      ActivityUtil.getInstance().app?.pushPathByName(name, param, onPop, animated)
    }
  }

  public static finish(param?: Object | null, animated?: boolean) {
    ActivityUtil.getInstance().app?.pop(param, animated)
  }

  public static finishAndStartActivity(name: string, param?: Object | null, animated?: boolean) {
    let pathNameArray = ActivityUtil.getInstance().app!!.getAllPathName()
    if (pathNameArray.includes(name)) {
      //存在值就用popToName
      ActivityUtil.getInstance().app!!.popToName(name, param, animated)
    } else {
      ActivityUtil.getInstance().app?.pop()
      //不存在popToName api会失效，那么改用pushPathByName
      ActivityUtil.getInstance().app?.pushPathByName(name, param, animated)
    }

  }


  public static finishByName(...names: string[]) {
    names.forEach((value, index) => {
      ActivityUtil.getInstance().app?.removeByName(value)
    })
  }

  public static finishAllPagesExceptNewest() {
    let pathNameArray = ActivityUtil.getInstance().app!!.getAllPathName()
    pathNameArray.forEach((pathName, index) => {
      if (index != pathNameArray.length - 1) {
        console.debug("ActivityUtil", "finishAllPagesExceptNewest", pathName)
        ActivityUtil.getInstance().app!!.removeByName(pathName)
      }
    })
  }

  public static finishAllPagesExcept(...names: string[]) {
    let pathNameArray = ActivityUtil.getInstance().app!!.getAllPathName()
    pathNameArray.forEach((pathName, index) => {
      if (!names.includes(pathName)) {
        ActivityUtil.getInstance().app!!.removeByName(pathName)
      }
    })
  }


  public static getAllPagesName(): Array<string> {
    return ActivityUtil.getInstance().app!!.getAllPathName()
  }

  public static replacePathByName(name: string, param?: Object | null, animated?: boolean) {
    ActivityUtil.getInstance().app!!.replacePathByName(name, param, animated)
  }

  public static getSystemSettings(packageName: string) {
    let context: common.UIAbilityContext = getContext() as common.UIAbilityContext
    let wantInfo: Want = {
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'application_info_entry',
      parameters: {
        pushParams: packageName // 打开指定应用的详情页面
      }
    }
    context.startAbility(wantInfo).then(() => {
      // this.openSetting = true
      // ...
    }).catch((err: BusinessError) => {
      // ...
    })
  }
}