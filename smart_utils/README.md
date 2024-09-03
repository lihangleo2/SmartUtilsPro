
# <center>smart-utils (API12 - Dev: 5.0.3.600)</center>

一个智能的常用工具类库，让你少走鸿蒙开发弯路。

+ 极简api
+ 几行代码即可实现功能
+ 持续更新

## 一 安装

```typescript
ohpm i @leo2/smart_utils
```

## 二 API介绍

smart_utils全部工具类介绍。[下载完整demo体验](https://github.com/lihangleo2/SmartUtilsPro)

| 模块                      | 介绍      |
|:------------------------|:--------|
| SmartPermissionUtil     | 权限请求框架  |
| SmartTimer              | 倒计时工具类  |
| SmartDataSource              | 数据懒加载类  |
| ActivityUtil            | 页面跳转工具类 |
| AppUpdateUtil            | 版本更新工具类 |

## 三 使用

### 3.1、SmartPermissionUtil 权限申请工具类
```typescript
SmartPermissionUtil.requestPermissions('ohos.permission.CAMERA')
    .subscribe(() => {
    //全部权限请求成功回调

  }, (noAgreePermissions,isDenied) => {

    if (isDenied) {
      MyXPopupUtil.showPop(this.mXpop!!)
    }else {
      ToastUtil.showToast("请打开相关权限")
    }

  })

// 使用说明
// 1. requestPermissions() 支持参数一直逗号下去，
//     如申请2个权限：requestPermissions('ohos.permission.CAMERA', 'ohos.permission.MICROPHONE')
//  
// 2. onFail参数说明
//     noAgreePermissions:Array<Permissions> 被拒绝的权限
//     isDenied：false -> 有系统权限弹窗；属于第一次申请，拒绝某权限时回调
//               true -> 没有系统权限弹窗；第二次申请（第一次拒绝了权限），弹权限设置pop,去手机设置
```
<br>

### 3.2、SmartTimer 计时器类
```typescript
//使用案例
//1.初始化SmartTimer
//参数1：表示每隔多少毫秒响应一次
//参数2：表示总共经历多少时间totalTime。达到totalTime后，计时器停止
codeTimer: SmartTimer = new SmartTimer(1000, 60000)

//2.设置监听
//回调1：还剩下的时间，总时间减去已经响应过的时间
//回调2：达到totalTime停止后，计时器停止回调onFinish
this.codeTimer.setListener((elapseTime) => {
  this.codeMessage = `重新获取${elapseTime / 1000}s`
}, () => {
  this.codeMessage = '获取验证码'
})
  
//3.开始计时
this.codeTimer.star()

//4.暂停计时
this.codeTimer.pause()

//5.恢复计时
this.codeTimer.resume()

//6.取消计时
this.codeTimer.cancle()
```
<br>

### 3.3、SmartDataSource 数据懒加载类
```typescript
//初始化数据
private listDatas: SmartDataSource<WordsBean> = new SmartDataSource();

//列表控件使用LazyForEach懒加载数据。
//【特别注意】：如果用到增加和删除改变了index后，index混乱了，要保证index正确，必须重写LazyForEach第三个参数：index + "_" + item.id（只要保证唯一key即可） 
List({ space: 20, initialIndex: 0 }) {
  LazyForEach(this.listDatas, (item: WordsBean, index: number) => {
    ListItem() {
      Text(`我是列表item == ${item}`)
        .width('90%')
        .height(100)
        .backgroundColor("#ff7184fc")
        .textAlign(TextAlign.Center)
    }
  }, (item: WordsBean, index: number) => index + "_" + item.id)
}


//添加单个数据 / 添加数组数据 addData()支持"单个数据"和"数组"
this.listDatas.addData("数据")
  
//从某个index插入数据，同理支持"数组"
this.listDatas.addData("数据",index)

//更新某个数据数据 index
this.listDatas.updateData("数据",index)
  
//删除某个数据 index
this.listDatas.deleteData(index)

//修改数据源datas
this.listDatas.modifyData(datas)
```
<br>

### 3.4、ActivityUtil 页面跳转工具类（需使用系统Navigation）
注意要使用此工具类，必须结合系统的Navigation使用，必须结合系统的Navigation使用，必须结合系统的Navigation使用。

知道这点，那么接下来完成3.4.1和3.4.2就可以使用ActivityUtil工具类

+ 3.4.1、第一步，在入口文件初始化
```typescript
@Entry
@Component
struct Index {
  @Provide app: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    //初始化 NavPathStack
    ActivityUtil.init(this.app)
  }

  build() {

    Navigation(this.app) {

    }
    .hideTitleBar(true)
    .navDestination(this.navDestinationRouter)
    .mode(NavigationMode.Stack)
  }

  @Builder
  navDestinationRouter(routerName: string, params: Object) {
    //按系统api的实现，必须实现，否则跳转不正常。有多少页面都要在此实现
    if (routerName === "MainPage") {
      MainPage()
    }
  }
}
```

+ 3.4.2、第二步，子页面
```typescript
@Entry
@Component
export struct MainPage {
  build() {
    NavDestination() {
      Column() {
        Button('子页面', { type: ButtonType.Capsule, stateEffect: true })
          .id('button_capsule')
          .backgroundColor("#ff4063ef")
          .height('30lpx')
          .margin({ top: '30lpx' })
        
      }
      .height('100%')
        .width('100%')
    }
    .hideTitleBar(true)
  }
}
```

+ 3.4.3、ActivityUtil的使用
```typescript
//跳转相关
ActivityUtil.startActivity({
  name: 'Login', //跳转页面name (必填)
  param: 1, //跳转是否带参数 (非必填)
  launchMode: LaunchMode.POP_TO_SINGLETON, //跳转是否带启动模式 (非必填)
  animated: true, //是否带跳转动画 (非必填)
  onPop: (popInfo) => { //监听上一个页面回调监听(非必填)
    console.debug("页面回调", 'Pop page name is: ' + popInfo.info.name + ', result: ' + JSON.stringify(popInfo.result))
  }
})

//关闭页面
ActivityUtil.finish()

//关闭页面，并传值
ActivityUtil.finish("数据")

//关闭栈内存在的页面：参数支持一直逗号下去如：ActivityUtil.finishByName("SplashPage","其他页面","其他页面")
ActivityUtil.finishByName("SplashPage")

//关闭页面，并跳转到指定页面，（如果"Login"在栈内存在，则关闭页面并跳转。如果不存在，则关闭页面并新建Login后跳转）
ActivityUtil.finishAndStartActivity("Login")

//关闭页面，并跳转到指定页面并传值
ActivityUtil.finishAndStartActivity("Login","数据")

//关闭栈内所有页面，最新的页面除外
ActivityUtil.finishAllPagesExceptNewest()

//关闭栈内所有页面，除了参数内的页面:：参数支持一直逗号下去如：ActivityUtil.finishAllPagesExcept("HomePage","其他页面","其他页面")
ActivityUtil.finishAllPagesExcept("HomePage")

//系统的replace方法，替换页面
ActivityUtil.replacePathByName("SplashPage")

//获取栈内所有页面
ActivityUtil.getAllPagesName()

//去系统设置页面，参数为app包名，意思跳转到某个app的系统设置
ActivityUtil.goSystemSettings('packageName')
```
<br>

### 3.5、AppUpdateUtil 版本更新工具类
本版本工薪库，是基于系统上二次封装。如果用户已上架华为市场，是会弹系统更新弹窗跳转华为市场的
```typescript
//最简单使用
AppUpdateUtil.checkAppUpdate()
  
//考虑用户体验，因为checkAppUpdate属于异步操作，最好是展示loading,这里也有封装  
AppUpdateUtil.checkAppUpdate(()=>{
  //在这里做showLoading操作
},()=>{
  //在这里做hideLoading操作
})  

```

## 📚开源协议

本项目基于 [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html) ，拷贝和借鉴代码请标注来源。