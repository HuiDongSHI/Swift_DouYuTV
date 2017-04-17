//
//  PageContentView.swift
//  DouYuTV
//
//  Created by HuiDong Shi on 2017/4/14.
//  Copyright © 2017年 HuiDongShi. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

protocol PageContentViewDelegate:class{
    func pagecontentViewScroll(contentView:PageContentView, progress:CGFloat, sourceIndex:Int, targetIndex:Int)
}

class PageContentView: UIView{
    //MARK: - 定义属性
    fileprivate var childVcs:[UIViewController]
    fileprivate weak var parentViewController:UIViewController?
    fileprivate var startOffsetx:CGFloat = 0
    fileprivate var lastOffsetX:CGFloat = 0
    fileprivate var isForbid:Bool = false
    
    weak var delegate:PageContentViewDelegate?
    
    //MARK: - 懒加载属性
    fileprivate lazy var collectionView:UICollectionView = {[weak self] in
        // 1. 设置布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.frame.size)!
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2.创建collectionView
        let collectionView = UICollectionView(frame: CGRect(x:0,y:0,width:(self?.frame.width)!, height:(self?.frame.height)!), collectionViewLayout: layout);
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        return collectionView
    }()
    
    //MARK: - 自定义构造函数
    init(frame: CGRect, childVcs:[UIViewController], parentViewController:UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 设置UI界面
extension PageContentView{
    fileprivate func setupUI(){
        // 1. 将所有的自控制器 添加到夫控制器中
        for vc in childVcs{
            parentViewController?.addChildViewController(vc)
        }
        // 2. 添加UICollectionView 用来存放控制器的View
        addSubview(collectionView)
    }
}
//MARK: - UICollectionView DataSource
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let childVC = childVcs[indexPath.item]
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}
//MARK: - 对外暴露的方法
extension PageContentView{
    func setSelectIndex(_ selectIndex:Int){
        // 1. 记录需要禁止代理方法
        isForbid = true
        // 2. 滚动到指定位置
        let offsetX:CGFloat = CGFloat(selectIndex) * kScreenW
        collectionView.setContentOffset(CGPoint(x:offsetX, y:0), animated: true)
    }
}
//MARK: - collectionView 滚动监听
extension PageContentView:UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbid = false

        startOffsetx = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0. 判断是否是点击事件
        if isForbid {return}
        
        // 1. 定义需要的数据
        var progress:CGFloat = 0
        var sourceIndex:Int = 0
        var targetIndex:Int = 0
        // 2. 判断是左滑还是右滑
        let currentOffsetx = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        if currentOffsetx > lastOffsetX { // 左滑
            // 1. 进度
            progress = currentOffsetx / scrollViewW - floor(currentOffsetx / scrollViewW)
            // 2. 当前页index
            sourceIndex = Int((currentOffsetx)/scrollView.frame.width);
            // 3. 目的页index
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex -= 1
            }
            // 4. 如果完全滑过去
            if currentOffsetx - startOffsetx == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else{  // 右滑
            progress = 1 - (currentOffsetx / scrollViewW - floor(currentOffsetx / scrollViewW))
            // 目的页index
            targetIndex = Int(currentOffsetx/scrollView.frame.width);
            // 当前页index
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count{
                targetIndex -= 1
            }
        }

        
        
        // 3. 将 progress/targetIndex/sourceIndex 传给 titleView
        self.delegate?.pagecontentViewScroll(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex) 
    
        lastOffsetX = scrollView.contentOffset.x
    }
    
}



