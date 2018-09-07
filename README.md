项目说明：
1、ADLoopView：
自定义图片轮播控件
2、ADLoopViewDemo
使用轮播控件Demo
3、ADLoopInTableView
轮播控件配合UITableView实现淘宝产品详情的上滑覆盖效果
4、HeadImageInTableView
UIImageView配合UITableView实现淘宝产品详情的上滑覆盖效果

ADLoopView控件说明：
#可以加载网络图片、本地图片，自动判断是否网络图片

#支持自动播放、自定义延时

#通过代理方法获取点击图片序号：
adLoopView(adLoopView: ADLoopView ,index: NSInteger)

#通过公有方法修改分页标签样式和尺寸：
setPageImge(pageImage: String, currentPageImage: String, dotWidth: CGFloat = 20.0, dotHeight: CGFloat = 3.0, dotMargin: CGFloat = 5.0)

#通过设置公有属性修改分页标签的位置（.left .center .right）：
pagePosition

更多功能完善ing...
