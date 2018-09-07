//
//  UINavigationBar+Alpha.swift
//  HeadImageInTableView
//
//  Created by 李家斌 on 2018/9/6.
//  Copyright © 2018年 李家斌. All rights reserved.
//

import Foundation
import UIKit

fileprivate var maskView: UIView?

extension UINavigationBar {
    func ad_setBackgroundColor(backgroundColor: UIColor) {
        if maskView == nil {
            self.setBackgroundImage(UIImage(), for: .default)
            /// 获取状态栏高度
            let statusHeight = UIApplication.shared.statusBarFrame.height
            maskView = UIView(frame: CGRect(x: 0, y: 0, width:self.bounds.width, height: self.bounds.height + statusHeight))
            maskView?.isUserInteractionEnabled = false
            maskView?.autoresizingMask = .flexibleWidth
            self.subviews.first?.insertSubview(maskView!, at: 0)
        }
        maskView?.backgroundColor = backgroundColor
    }
    
}
