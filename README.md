#### 相关链接：
* [iOS开发中dismiss到最底层控制器的方法](http://blog.csdn.net/nunchakushuang/article/details/45198969 "悬停显示")<br>
* [iOS实时获取当前的屏幕方向之重力感应](http://www.jianshu.com/p/72d6c63006b3 "悬停显示")<br>
* [IOS 图片上传处理 图片压缩 图片处理](http://www.open-open.com/lib/view/open1375933073921.html"悬停显示")<br>
* [iOS开发-自定义专属相册 (详细)| 干货](http://blog.csdn.net/dongtinghong/article/details/51644845"悬停显示")<br>

主要分为三个部分：
#### 1. 选择证照附件页面（`起中转作用`）
  此页面一方面接收来自服务器的相关数据，对其内容进行处理，展示到页面上，另一方面，<br>
  `接收来自相册或者照相机传过来的图片`，`对图片进行压缩等`，`上传到服务器中`<br>
  ![](https://github.com/anchoriteFili/CustomPhoto/blob/master/定制相册部分/定制相册部分/展示文件/选择证照附件.png)
#### 2. 相机胶卷模块
  此页面是自定义相册部分，从手机相册中获取相关相册和图片进行展示，并对图片的处理<br>
  主要难点：`大量显示图片卡顿`.<br>
  ![](https://github.com/anchoriteFili/CustomPhoto/blob/master/定制相册部分/定制相册部分/展示文件/相册.png)<br>
#### 3. 照相模块
  此模块是自定义相机部分，里边添加了`可以将拍的照片显示到一个collectionView上进行显示`<br>
  ![](https://github.com/anchoriteFili/CustomPhoto/blob/master/定制相册部分/定制相册部分/展示文件/相机.png)<br>

