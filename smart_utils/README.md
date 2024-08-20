
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

smart_utils全部工具类介绍

| 模块                       | 介绍     |
|:-------------------------|:-------|
| SmartPermissionUtil         | 权限请求框架 |
| SmartTimer              | 倒计时工具类 |

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


## 📚开源协议

本项目基于 [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html) ，拷贝和借鉴代码请标注来源。