//
//  ViewController.swift
//  ADLoopViewDemo
//
//  Created by 李家斌 on 2018/9/6.
//  Copyright © 2018年 李家斌. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width)
        let imagesLocal = NSArray(array: ["img1", "img2", "img3", "img4"])
        let imagesWeb = NSArray(array: [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536138710020&di=ff98e17de2ab7c3088182b4a227f8dac&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1408%2F28%2Fc1%2F37950569_1409156831122_800x800.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536138767193&di=5be964c456d7abbd7d4ea68bb112c49d&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1606%2F30%2Fc3%2F23589301_1467290861869_800x800.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536733512&di=691993f345083ac8bb79ab19ce71a50b&imgtype=jpg&er=1&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1601%2F31%2Fc0%2F18075531_1454249261384_800x800.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536138810236&di=0b993858f7bd97cd8bc7284c7db7a064&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1606%2F30%2Fc2%2F23579206_1467279001712_800x800.jpg"])
        let loopView = ADLoopView(frame: frame, images: imagesWeb, placeholder: UIImage(named: "ad"))
        loopView.delegate = self
        loopView.pagePosition = .right
                loopView.setPageImge(pageImage: "page", currentPageImage: "currentPage")
        //        loopView.setPageImge(pageImage: "page", currentPageImage: "currentPage", dotWidth: 50, dotHeight: 6, dotMargin: 10)
        view.addSubview(loopView)
    }
}

/// ADLoopView代理方法
extension ViewController: ADLoopViewDelegate {
    func adLoopView(adLoopView: ADLoopView, index: NSInteger) {
        print("点击了第\(index)张图片")
    }
}

extension ViewController {
    /// 转换状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
