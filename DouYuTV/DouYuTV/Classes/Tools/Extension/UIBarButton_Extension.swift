//
//  UIBarButton_Extension.swift
//  DouYuTV
//
//  Created by HuiDong Shi on 2017/4/14.
//  Copyright © 2017年 HuiDongShi. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
//     1. 类方法
//    class func createItem(image:UIImage, highImage:UIImage, size:CGSize) -> UIBarButtonItem{
//        let btn = UIButton()
//        btn.setImage(image, for: .normal);
//        btn.setImage(highImage, for: .highlighted)
//        btn.frame = CGRect(origin: CGPoint(x:0, y:0), size: size);
//        return UIBarButtonItem(customView: btn)
//    }
    
    
//     2.便利构造函数 1. 必须以convenience开头
//                2. 在构造函数中必须明确调用一个设计的构造函数（使用self调用）
    convenience init(image : String, highImage : String="", size : CGSize=CGSize(width: 0, height: 0 )){
        // 1. 创建按钮
        let btn = UIButton()
        // 2. 设置图片
        btn.setImage(UIImage(named:image), for: .normal);
        btn.setImage(UIImage(named:highImage), for: .highlighted)
        // 3. 设置尺寸
        if size == CGSize(width:0, height:0) {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint(x:0, y:0), size: size);
        }
        // 4. 创建UIBarButtonItem
        self.init(customView:btn)
    }
}
