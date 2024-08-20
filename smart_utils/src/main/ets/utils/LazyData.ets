// Basic implementation of IDataSource to handle data listener
@Observed
class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}


/*
 * 项目中的用法
 *
 * 1.初始化数据
 private wordsDatas: SmartDataSource<WordsBean> = new SmartDataSource();
 *
 * 2.LazyForEach上加上数据即可
 LazyForEach(this.wordsDatas, (item: WordsBean, index: number) => {}
 *
 * 3.网络请求回来以后，调用如下即可添加数据
 this.wordsDatas.addData(bean)
 //如果想改变数据源，有点类似android的setData()可以使用modifyData()
 //this.wordsDatas.modifyData(bean)
 * */


//所有api
//
//添加单个数据 / 添加数组数据 addData()支持"单个数据"和"数组"
//this.listDatas.addData("数据")
//从某个index插入数据，同理支持"数组"
//this.listDatas.addData("数据",index)

//更新某个数据数据 index
//this.listDatas.updateData("数据",index)
//删除某个数据 index
//this.listDatas.deleteData(index)

//修改数据源datas
//this.listDatas.modifyData(datas)



/*
 * 特别注意：
 * 1.有局部更新如调用了 notifyDataChange。--> LazyForEach必须重写第三个参数
 * 2. 如果用到增加和删除改变了index后，index混乱了，要保证index正确 --> LazyForEach必须重写第三个参数
 * 代码如下：
    LazyForEach(this.wordsDatas, (item: WordsBean, index: number) => {

    },(item: WordsBean, index: number) => index+"_"+item.id) //如果你的bean对象没有id可以用：index+"_"+JSON.stringify(item)
 * */

export class SmartDataSource<T> extends BasicDataSource<T> {
  private dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    return this.dataArray[index];
  }

  public updateData(data: T,index: number): void {
    this.dataArray[index] = data
    this.notifyDataChange(index)
    // this.deleteData(index)
    // this.addData(data,index)
  }

  public deleteData(index: number): void {
    let lasIndex = this.dataArray.length-1
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
    if (lasIndex != index) {
      this.notifyDataReload()
    }
  }


  public addData(data: T | T[], index?: number): void {
    if (data instanceof Array) {
      if (index == undefined) {
        this.dataArray = this.dataArray.concat(data)
        this.notifyDataAdd(this.dataArray.length - 1);
      } else {
        data.reverse().forEach((item) => {
          this.dataArray.splice(index, 0, item);
          this.notifyDataAdd(index);
        })
        this.notifyDataReload()
      }
    } else {
      if (index == undefined) {
        this.dataArray.push(data);
        this.notifyDataAdd(this.dataArray.length - 1);
      } else {
        this.dataArray.splice(index, 0, data);
        this.notifyDataAdd(index);
        this.notifyDataReload()
      }
    }
  }


  public modifyData(data: T[]) {
    const promise: Promise<void> = new Promise((resolve: Function) => {
      this.dataArray = []
      this.notifyDataReload()
      setTimeout(() => {
        this.dataArray = this.dataArray.concat(data)
        this.notifyDataAdd(this.dataArray.length - 1);
      },10)
    })
  }
}