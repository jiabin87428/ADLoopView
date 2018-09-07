//
//  BaseInfoCell.swift
//  ADLoopInTableView
//
//  Created by 李家斌 on 2018/9/6.
//  Copyright © 2018年 李家斌. All rights reserved.
//

import UIKit

class BaseInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expressFee: UILabel!
    @IBOutlet weak var mSales: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
