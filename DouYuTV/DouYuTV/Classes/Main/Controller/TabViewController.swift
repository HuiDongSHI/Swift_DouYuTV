//
//  TabViewController.swift
//  DouYuTV
//
//  Created by HuiDong Shi on 2017/4/14.
//  Copyright © 2017年 HuiDongShi. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(storyName: "Home")
        addChild(storyName: "Live")
        addChild(storyName: "Follow")
        addChild(storyName: "Profile")
        
        }
    
    private func addChild(storyName:String){
        // 1. 通过storyBoard获取vc
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        // 2. 添加子控制器
        addChildViewController(childVC)

    }
}
