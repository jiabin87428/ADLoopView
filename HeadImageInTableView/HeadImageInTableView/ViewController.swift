//
//  ViewController.swift
//  HeadImageInTableView
//
//  Created by 李家斌 on 2018/9/6.
//  Copyright © 2018年 李家斌. All rights reserved.
//

import UIKit

let celCount = 50
let rowHeight = 80.0

let baseInfoCell = "BaseInfoCell"

class ViewController: UITableViewController {
    
    var imageView : UIImageView?
    
    /// 头部View高度
    var headerHeight: CGFloat = 0
    /// 导航栏透明度变化点
    var navBarChangePoint: CGFloat = 0
    /// 导航栏标题
    var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化变量
        headerHeight = self.view.bounds.width
        navBarChangePoint = 50.0
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        titleLab.text = "视觉差滚动效果"
        titleLab.textColor = .clear
        self.navigationItem.titleView = titleLab
        self.titleLabel = titleLab
        
        tableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
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
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: -self.view.bounds.width, width: self.view.bounds.width, height: self.view.bounds.width))
        self.imageView!.contentMode = .scaleAspectFill
        self.imageView!.image = UIImage(named: "img2")
        self.imageView!.clipsToBounds = true
        self.imageView?.isUserInteractionEnabled = true
        self.imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgClick)))
        
        self.tableView.addSubview(self.imageView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.ad_setBackgroundColor(backgroundColor: .clear)
    }
    
    @objc func imgClick() {
        print("点击了图片")
    }
}

// MARK: UITableView
extension ViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.imageView != nil else {
            return
        }
        let offsetY = scrollView.contentOffset.y + headerHeight
        self.imageView!.frame = CGRect(x: self.imageView!.frame.origin.x, y: scrollView.contentOffset.y, width: self.imageView!.frame.width, height: max(0, headerHeight - offsetY))
        
        if (offsetY > navBarChangePoint) {
            let alpha = min(1, 1 - (navBarChangePoint + 64 - offsetY) / 64)
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

