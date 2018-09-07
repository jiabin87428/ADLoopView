//
//  ViewController.swift
//  ADLoopInTableView
//
//  Created by 李家斌 on 2018/9/6.
//  Copyright © 2018年 李家斌. All rights reserved.
//

import UIKit

let celCount = 50
let rowHeight = 80.0

let baseInfoCell = "BaseInfoCell"

class ViewController: UITableViewController {
    
    /// 头部View高度
    var headerHeight: CGFloat = 0
    /// 导航栏透明度变化点
    var navBarChangePoint: CGFloat = 0
    /// 导航栏标题
    var titleLabel: UILabel?
    /// 轮播组件
    var loopView : ADLoopView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //初始化变量
        headerHeight = self.view.bounds.width
        navBarChangePoint = 50.0
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        titleLab.text = "轮播+滚动差"
        titleLab.textColor = .clear
        self.navigationItem.titleView = titleLab
        self.titleLabel = titleLab
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        tableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 0)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: baseInfoCell, bundle: nil), forCellReuseIdentifier: baseInfoCell)
        
        extendedLayoutIncludesOpaqueBars = true;
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: self.view.bounds.width, left: 0, bottom: 0, right: 0)
        
        let loopView = self.createADLoopView()
        self.tableView.addSubview(loopView)
    }
    
    func createADLoopView() -> ADLoopView {
        let frame = CGRect(x: 0, y: -self.view.bounds.width, width: self.view.bounds.width, height: self.view.bounds.width)
        let imagesLocal = NSArray(array: ["img1", "img2", "img3", "img4"])
        let imagesWeb = NSArray(array: [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536138710020&di=ff98e17de2ab7c3088182b4a227f8dac&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1408%2F28%2Fc1%2F37950569_1409156831122_800x800.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536138767193&di=5be964c456d7abbd7d4ea68bb112c49d&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1606%2F30%2Fc3%2F23589301_1467290861869_800x800.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536733512&di=691993f345083ac8bb79ab19ce71a50b&imgtype=jpg&er=1&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1601%2F31%2Fc0%2F18075531_1454249261384_800x800.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1536138810236&di=0b993858f7bd97cd8bc7284c7db7a064&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1606%2F30%2Fc2%2F23579206_1467279001712_800x800.jpg"])
        let loopView = ADLoopView(frame: frame, images: imagesWeb, placeholder: UIImage(named: "ad"))
        loopView.clipsToBounds = true
        loopView.delegate = self
        loopView.pagePosition = .right
        loopView.setPageImge(pageImage: "page", currentPageImage: "currentPage")
        self.loopView = loopView
        
        return loopView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.ad_setBackgroundColor(backgroundColor: .clear)
    }
}

// MARK: UITableView
extension ViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.loopView != nil else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y + headerHeight
        self.loopView!.frame = CGRect(x: self.loopView!.frame.origin.x, y: scrollView.contentOffset.y, width: self.loopView!.frame.width, height: max(0, headerHeight - offsetY))
        self.loopView!.refreshImgFrame()
        
        if (offsetY > navBarChangePoint) {
            let alpha = min(1, 1 - (navBarChangePoint + 64 - offsetY) / 64)
            if alpha > 0.5 {
                UIApplication.shared.statusBarStyle = .default
            }else {
                UIApplication.shared.statusBarStyle = .lightContent
            }
            self.navigationController?.navigationBar.ad_setBackgroundColor(backgroundColor: UIColor.white.withAlphaComponent(alpha))
            self.titleLabel?.textColor = UIColor.darkGray.withAlphaComponent(alpha)
        } else {
            self.navigationController?.navigationBar.ad_setBackgroundColor(backgroundColor: UIColor.white.withAlphaComponent(0))
            self.titleLabel?.textColor = .clear
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: baseInfoCell, for: indexPath) as! BaseInfoCell
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: ADLoopViewDelegate {
    func adLoopView(adLoopView: ADLoopView, index: NSInteger) {
        print("\(index)")
    }
}

