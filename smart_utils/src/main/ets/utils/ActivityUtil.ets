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
 * 跳转相关
   ActivityUtil.startActivity({
     name: 'Login', //跳转页面name (必填)
     param: 1, //跳转是否带参数 (非必填)
     launchMode: LaunchMode.POP_TO_SINGLETON, //跳转是否带启动模式 (非必填)
     animated: true, //是否带跳转动画 (非必填)
     onPop: (popInfo) => { //监听上一个页面回调监听(非必填)
        console.debug("页面回调", 'Pop page name is: ' + popInfo.info.name + ', result: ' + JSON.stringify(popInfo.result))
     }
   })

 * 使用提示：
   1.你只需要ActivityUtil.startActivity({})就会有代码提示，其中name为必填项，会主动生成。其他根据需要写入可参考如下：
    interface ActivityInfo{
      //跳转name (必填)
      name: string

      //跳转参数 (非必填)
      param?: Object | null

      //启动模式 (非必填)
      launchMode?: LaunchMode

      //是否带跳转动画 (非必填)
      animated?: boolean;

      //跳转监听，如：A跳B，A监听B回来 (非必填)
      onPop?: (popInfo: PopInfo) => void
    }

   2.启动模式详解
   * LaunchMode.STANDARD: 默认启动模式，开启几个就有几个
   * LaunchMode.MOVE_TO_TOP_SINGLETON: 从栈底向栈顶查找，如果指定的名称已经存在，则将对应的NavDestination页面移到栈顶
   * LaunchMode.POP_TO_SINGLETON: 从栈底向栈顶查找，如果指定的名称已经存在，则将其上方的NavDestination页面全部移除
   * LaunchMode.NEW_INSTANCE: 测试下来和STANDARD模式效果一致，栈内都打印出来多个了。（android里也会多个，但会新建栈，仅供参考）
   *                          以下是官方注释：创建新的NavDestination实例。与STANDARD模式相比，该方法不会复用栈中同名实例。

   * *******************************************************************************************************************
   *
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
   ActivityUtil.finishAndStartActivity({
      name: 'Login'
   })
   *
   * 关闭页面，并跳转到指定页面并传值
   ActivityUtil.finishAndStartActivity({
      name: 'Login',
      param: "数据"
   })
   *
   * 关闭栈内所有页面，最新的页面除外
   ActivityUtil.finishAllPagesExceptNewest()
   *
   * 关闭栈内所有页面，除了参数内的页面:：参数支持一直逗号下去如：ActivityUtil.finishAllPagesExcept("HomePage","其他页面","其他页面")
   ActivityUtil.finishAllPagesExcept("HomePage")
   *
   * 系统的replace方法，替换页面
   ActivityUtil.replacePathByName("SplashPage")
   *
   * 获取栈内所有页面
   ActivityUtil.getAllPagesName()
   *
   * 去系统设置页面
   ActivityUtil.goSystemSettings('packageName')
 * */
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

  public static startActivity(activityInfo:ActivityInfo) {
    ActivityUtil.getInstance().app?.pushPath(new NavPathInfo(activityInfo.name, activityInfo.param, activityInfo.onPop), { launchMode: activityInfo.launchMode,animated:activityInfo.animated })
  }



  public static finish(param?: Object | null, animated?: boolean) {
    ActivityUtil.getInstance().app?.pop(param, animated)
  }

  public static finishAndStartActivity(activityInfo:ActivityInfo) {
    let pathNameArray = ActivityUtil.getInstance().app!!.getAllPathName()
    let name = activityInfo.name
    if (pathNameArray.includes(name)) {
      //存在值就用popToName
      ActivityUtil.getInstance().app!!.popToName(name, activityInfo.param, activityInfo.animated)
    } else {
      ActivityUtil.getInstance().app?.pop()
      //不存在popToName api会失效，那么改用pushPath
      // ActivityUtil.getInstance().app?.pushPath(new NavPathInfo(name, param), options)
      ActivityUtil.getInstance().app?.pushPath(new NavPathInfo(name, activityInfo.param,activityInfo.onPop), { launchMode: activityInfo.launchMode,animated:activityInfo.animated })
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

  public static goSystemSettings(packageName: string) {
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


interface ActivityInfo{
  //跳转name
  name: string

  //跳转参数
  param?: Object | null

  //跳转监听，如：A跳B，A监听B回来
  onPop?: (popInfo: PopInfo) => void

  //启动模式
  launchMode?: LaunchMode

  //是否带跳转动画
  animated?: boolean;
}

