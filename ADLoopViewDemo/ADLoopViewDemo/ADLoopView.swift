//
//  ADLoopView.swift
//  KVCTest001
//
//  Created by 李家斌 on 2018/9/4.
//  Copyright © 2018年 李家斌. All rights reserved.
//

import UIKit

/// 分页控件位置
enum PAGECONTROL_POSITION: Int {
    case left = 1
    case center = 2
    case right = 3
}

/// 分页点宽度
private var dotW: CGFloat = 7.0
/// 分页点高度
private var dotH: CGFloat = 7.0
/// 分页点间隔
private var margin: CGFloat = 4.0

class ADLoopView: UIView {
    // MARK: 共有属性
    /// 分页控件位置 默认.center
    /// - parameter .left   :居左
    /// - parameter .center :居中
    /// - parameter .right  :居右
    var pagePosition = PAGECONTROL_POSITION.center{
        didSet{
            guard pageControl != nil else {
                return
            }
            let marginX = margin + dotW
            let newW: CGFloat = CGFloat(pageControl!.subviews.count) * marginX - margin
            pageControl!.frame = CGRect(x: pageControl!.frame.origin.x, y: pageControl!.frame.origin.y, width: newW, height: pageControl!.frame.size.height)
            if pagePosition == .left{
                pageControl!.frame = CGRect(x: 10, y: pageControl!.frame.origin.y, width: pageControl!.frame.width, height: pageControl!.frame.height)
            }
            if pagePosition == .center{
                var center = pageControl!.center
                center.x = self.center.x
                pageControl!.center = center
            }
            if pagePosition == .right{
                pageControl!.frame = CGRect(x: self.frame.width - pageControl!.frame.width - 10, y: pageControl!.frame.origin.y, width: pageControl!.frame.width, height: pageControl!.frame.height)
            }
        }
    }
    var delegate: ADLoopViewDelegate?
    
    // MARK: 私有属性
    private var pageControl : ADPageControl?
    private var loopView : UIScrollView?
    private var placeholder : UIImage?
    private var currentPage = 0
    private var currentImgs = NSMutableArray()
    private var currentImages :NSMutableArray? {
        get{
            currentImgs.removeAllObjects()
            let count = self.imageList!.count
            var i = NSInteger(self.currentPage+count-1)%count
            currentImgs.add(self.imageList![i])
            currentImgs.add(self.imageList![self.currentPage])
            i = NSInteger(self.currentPage+1)%count
            currentImgs.add(self.imageList![i])
            return currentImgs
        }
    }
    
    private var imageList : NSArray?
    private var autoPlay = false
    private var delay : TimeInterval = 3
    
    /// 网络图片临时文件夹
    private var webImgDic : [String : Data] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, images: NSArray, autoPlay: Bool = false, delay: TimeInterval = 3, placeholder: UIImage? = nil) {
        self.init(frame: frame)
        self.imageList = images
        self.autoPlay = autoPlay
        self.delay = delay
        self.placeholder = placeholder
        
        self.initSetting()
    }
    
    convenience init(frame: CGRect, images: NSArray, placeholder: UIImage? = nil) {
        self.init(frame: frame)
        self.imageList = images
        self.placeholder = placeholder
        
        self.initSetting()
    }
    
    /// 初始化设置
    private func initSetting() {
        createImage()
        createLoopView()
        createPageControl()
        self.pagePosition = .center
        
        if self.imageList!.count<2{
            self.autoPlay = false
            pageControl?.isHidden = true
        }
        if self.autoPlay == true {
            startAutoPlay()
        }
    }
    
    // 创建图片
    private func createImage() {
        if imageList?.count == 0 {
            return
        }
        for i in 0..<self.imageList!.count {
            let urlStr = self.imageList![i] as! String
            var img = UIImage()
            if self.placeholder != nil {
                img = placeholder!
                self.webImgDic[urlStr] = UIImagePNGRepresentation(img)
            }
            if urlStr.hasPrefix("http") {// 图片来自网络
                self.loadWebImage(url: urlStr)
            }else {// 图片来自本地
                let localImg = UIImage(named: urlStr)
                if localImg != nil {
                    self.webImgDic[urlStr] = UIImagePNGRepresentation(localImg!)
                }
            }
        }
    }
    
    // 创建ScrollerVIew
    private func createLoopView() {
        if imageList?.count == 0 {
            return
        }
        loopView = UIScrollView(frame: self.bounds)
        loopView?.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        loopView?.showsHorizontalScrollIndicator = false
        loopView?.showsVerticalScrollIndicator = false
        loopView?.bounces = false
        loopView?.delegate = self
        loopView?.contentSize = CGSize(width: self.bounds.width*3, height: 0)
        loopView?.isPagingEnabled = true
        self.addSubview(loopView!)
        
        for i in 0..<3 {
            let imgView = UIImageView(frame: CGRect(x: self.bounds.width * CGFloat(i), y: 0, width: self.bounds.width, height: self.bounds.height))
            imgView.isUserInteractionEnabled = true
            
            let imgTap = UITapGestureRecognizer(target: self, action: #selector(imgViewClick))
            imgView.addGestureRecognizer(imgTap)
            if self.placeholder != nil {
                if webImgDic[self.imageList![i] as! String]! == UIImagePNGRepresentation(self.placeholder!) {
                    imgView.contentMode = .center
                }else {
                    imgView.contentMode = .scaleAspectFit
                }
            }
            imgView.image = UIImage(data: webImgDic[self.imageList![i] as! String]!)
            
            loopView?.addSubview(imgView)
        }
        refreshImages()
    }
    
    // 创建PageController
    private func createPageControl() {
        if imageList?.count == 0 {
            return
        }
        
        pageControl = ADPageControl(frame: CGRect(x: 0, y: self.bounds.height - 30, width: self.bounds.width, height: 30))
        pageControl?.numberOfPages = imageList!.count
        pageControl?.currentPage = 0
        pageControl?.isUserInteractionEnabled = false
        self.addSubview(pageControl!)
        
    }
    
    // 开始自动播放
    private func startAutoPlay() {
        self.perform(#selector(nextPage), with: nil, afterDelay: delay)
    }
    
    // 下一页
    @objc func nextPage() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(nextPage), object: nil)
        loopView?.setContentOffset(CGPoint(x: 2 * self.frame.width, y: 0), animated: true)
        self.perform(#selector(nextPage), with: nil, afterDelay: delay)
    }
    
    // 每次图片滚动时刷新图片
    private func refreshImages() {
        loopView!.contentOffset = CGPoint(x: self.frame.width, y: 0)
        for i in 0..<loopView!.subviews.count {
            let imageView = loopView!.subviews[i] as! UIImageView
            if self.placeholder != nil {
                if webImgDic[self.imageList![i] as! String]! == UIImagePNGRepresentation(self.placeholder!) {
                    imageView.contentMode = .center
                }else {
                    imageView.contentMode = .scaleAspectFit
                }
            }
            imageView.image = UIImage(data: webImgDic[self.currentImages![i] as! String]!)
        }
    }
    
    // 点击图片
    @objc func imgViewClick(tap: UITapGestureRecognizer) {
        if self.delegate != nil && self.delegate!.responds(to: #selector(ADLoopViewDelegate.adLoopView(adLoopView:index:))) {
            self.delegate?.adLoopView!(adLoopView: self, index: currentPage)
        }
    }
}

// MARK: ADLoopView公开方法
extension ADLoopView {
    /// 设置分页的图标
    /// - parameter pageImage           :分页图
    /// - parameter currentPageImage    :当前分页图
    /// - parameter dotWidth            :分页点宽度 默认20
    /// - parameter dotHeight           :分页点高度 默认3
    /// - parameter dotMargin           :分页点间隔 默认5
    func setPageImge(pageImage: String, currentPageImage: String, dotWidth: CGFloat = 20.0, dotHeight: CGFloat = 3.0, dotMargin: CGFloat = 5.0) {
        let pageImg = UIImage(named: pageImage)
        let currentPageImg = UIImage(named: currentPageImage)
        dotW = dotWidth
        dotH = dotHeight
        margin = dotMargin
        self.pagePosition = PAGECONTROL_POSITION(rawValue: self.pagePosition.rawValue)!
        pageControl?.setNeedsLayout()
        
        // 一定要两个图片都正确才能成功赋值
        if pageImg != nil && currentPageImg != nil{
            pageControl?.setValue(UIImage(named: pageImage), forKey: "_pageImage")
            pageControl?.setValue(UIImage(named: currentPageImage), forKey: "_currentPageImage")
        }
    }
}

// MARK: 工具方法
extension ADLoopView {
    /// 异步加载图片
    /// - parameter url             :网络图片地址
    /// - parameter placeholder     :占位图
    private func loadWebImage(url: String?) {
        if url == nil{
            return
        }
        
        if self.webImgDic[url!] != nil {
            if self.placeholder != nil {// 如果placeholder不为nil，需要判断存在Dic中的是不是占位图
                guard self.webImgDic[url!] == UIImagePNGRepresentation(self.placeholder!) else {
                    return
                }
            }
        }
        
        /// 全局队列异步执行
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            let imgUrl = URL(string: url!)
            let imgData = try? Data(contentsOf: imgUrl!)
            if imgData != nil {
                self?.webImgDic[url!] = imgData!
                DispatchQueue.main.async {[weak self] in
                    self?.refreshImages()
                }
            }
        }
        
    }
}

// MARK: UIScrollerView代理方法
extension ADLoopView: UIScrollViewDelegate {
    /// 滚动动画结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: true)
    }
    
    // 滚动栏滚动中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let width = self.frame.width
        if x >= 2 * width {
            currentPage = (currentPage + 1) % self.imageList!.count
            pageControl!.currentPage = currentPage
            refreshImages()
        }
        
        if x <= 0 {
            currentPage = (currentPage + self.imageList!.count - 1) % self.imageList!.count
            pageControl!.currentPage = currentPage
            refreshImages()
        }
    }
}

// MARK: ADLoopView代理方法
@objc protocol ADLoopViewDelegate : NSObjectProtocol {
    @objc optional
    // 点击图片事件
    func adLoopView(adLoopView: ADLoopView ,index: NSInteger)
}

// MARK: 自定义UIPageController
class ADPageControl: UIPageControl {
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.backgroundColor = .orange
        let marginX = margin + dotW
        
        for i in 0..<self.subviews.count {
            let dot = self.subviews[i]
            dot.frame = CGRect(x: CGFloat(i) * marginX, y: dot.frame.origin.y, width: CGFloat(dotW), height: CGFloat(dotH))
        }
    }
}
