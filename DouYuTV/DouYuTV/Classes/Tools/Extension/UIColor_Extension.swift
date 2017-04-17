//
//  UIColor_Extension.swift
//  DouYuTV
//
//  Created by HuiDong Shi on 2017/4/14.
//  Copyright © 2017年 HuiDongShi. All rights reserved.
//

import UIKit
extension UIColor{
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat){
        self.init(colorLiteralRed: Float(r/255.0), green: Float(g/255.0), blue: Float(b/255.0), alpha: 1.0)
    }
}
