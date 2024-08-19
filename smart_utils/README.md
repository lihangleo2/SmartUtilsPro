
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

以下配置中如果有和[全局配置](#全局配置)一样的名字函数，此次弹窗属性会按照本次配置生效

| 模块                       | 介绍     |
|:-------------------------|:-------|
| SmartPermissionUtil         | 权限请求框架 |
| SmartTimer              | 倒计时工具类 |

## 三 使用

### 3.1、SmartPermissionUtil 权限申请工具类
```typescript
MyPermissionUtil.requestPermissions('ohos.permission.CAMERA')
    .subscribe(() => {
    //全部权限请求成功回调

  }, (noAgreePermissions,isDenied) => {

    if (isDenied) {
      MyXPopupUtil.showPop(this.mXpop!!)
    }else {
      ToastUtil.showToast("请打开相关权限")
    }

  })


//1. requestPermissions() 支持参数一直逗号下去，
//    如申请2个权限：requestPermissions('ohos.permission.CAMERA', 'ohos.permission.MICROPHONE')
//  
//2. onFail参数说明
//    noAgreePermissions:Array<Permissions> 被拒绝的权限
//    isDenied：false -> 有系统权限弹窗；属于第一次申请，拒绝某权限时回调
//              true -> 没有系统权限弹窗；第二次申请（第一次拒绝了权限），弹权限设置pop,去手机设置
```



## 📚开源协议

本项目基于 [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html) ，拷贝和借鉴代码请标注来源。