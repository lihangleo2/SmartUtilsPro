import { ActivityUtil } from '@leo2/smart_utils';
import { AppRouter } from '../common/AppRouter';
import { MainPage } from './MainPage';
import { PermissionPage } from './permission/PermissionPage';
import { TimerPage } from './timer/TimerPage';

@Entry
@Component
struct Index {
  @Provide app: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    ActivityUtil.init(this.app)
    ActivityUtil.replacePathByName(AppRouter.activity_main)
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
    if (routerName === AppRouter.activity_main) {
      MainPage()
    } else if (routerName === AppRouter.activity_permission) {
      PermissionPage()
    }else if (routerName === AppRouter.activity_timer) {
      TimerPage()
    }
  }
}