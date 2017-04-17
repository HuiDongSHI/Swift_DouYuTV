//
//  HomeViewController.swift
//  DouYuTV
//
//  Created by HuiDong Shi on 2017/4/14.
//  Copyright © 2017年 HuiDongShi. All rights reserved.
//

import UIKit

private let kTitleViewH:CGFloat = 40

class HomeViewController: UIViewController {

    //MARK: - 懒加载属性
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let frame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView:PageTitleView = PageTitleView(frame: frame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    fileprivate lazy var pageContentView:PageContentView={[weak self] in
        // 1. 确定内容的frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH;
        let contentFrame = CGRect(x: 0, y: kStatusBarH+kNavigationBarH+kTitleViewH, width: kScreenW, height: contentH)
        // 2. 确定所有的自控制器
        var childVcs = [UIViewController]()
        for _ in 0..<4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let pagecontentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        pagecontentView.delegate = self
        
        return pagecontentView
    }()
    
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

//MARK: - 设置UI界面
extension HomeViewController{
    fileprivate func setupUI(){
        // 0.
        automaticallyAdjustsScrollViewInsets = false
        // 1. 设置导航栏
        setNavigationBar()
        // 2. 设置titleView
        view.addSubview(pageTitleView)
        // 3. 添加pageContentView
        view.addSubview(pageContentView)
    }
    
    private func setNavigationBar(){
        // 1. 设置左侧item
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: "logo")
        // 2. 设置右侧item
        let size = CGSize(width: 40, height: 40);
        
        let historyItem = UIBarButtonItem(image: "image_my_history", highImage: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(image: "btn_search", highImage: "btn_search_clicked", size: size)
        let qrCodeItem = UIBarButtonItem(image: "Image_scan", highImage: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrCodeItem];
    }
}

//MARK: - 遵守协议PageTitleViewDelegate
extension HomeViewController:PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int) {
        print(index)
        pageContentView.setSelectIndex(index)
    }
}

//MARK: - 遵守PageContentViewDelegate
extension HomeViewController:PageContentViewDelegate{
    func pagecontentViewScroll(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
