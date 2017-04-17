//
//  PageTitleView.swift
//  DouYuTV
//
//  Created by HuiDong Shi on 2017/4/14.
//  Copyright © 2017年 HuiDongShi. All rights reserved.
//

import UIKit

//MARK: - 定义协议
// 后面的class表示这个协议 只能被类遵守
protocol PageTitleViewDelegate:class {
    func pageTitleView(titleView:PageTitleView, selectIndex index:Int)
}

//MARK: - 定义常量
private let kScrollLineH:CGFloat = 2
private let kNormalColor:(CGFloat, CGFloat, CGFloat) = (85, 85, 85)       // 元祖
private let kSelectColor:(CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    //MARK: - 定义属性
    fileprivate var titles:[String]
    fileprivate var currentIndex = 0
    weak var delegate:PageTitleViewDelegate?
    
    //MARK: - 懒加载属性
    fileprivate lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var scrollLine:UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    fileprivate lazy var titleLabels:[UILabel] = [UILabel]()
    
    //MARK: - 自定义构造函数
    init(frame: CGRect, titles:[String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        // 1. 设置UI界面
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置UI界面
extension PageTitleView{
    fileprivate func setupUI(){
        // 1. 添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2. 添加titles对应的label
        setupTitleLables()
        // 3. 设置滚动huakuai
        setupBottomLineAndScrollLine()
    }
    private func setupTitleLables(){
        
        let labelW:CGFloat = frame.size.width / CGFloat(titles.count)
        let labelH:CGFloat = frame.size.height - kScrollLineH
        let labelY:CGFloat = 0
        
        for (index, title) in titles.enumerated(){
            // 1. 创建Label
            let label:UILabel = UILabel()
            // 2. 设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            // 3. 设置label的frame
            let labelX:CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4. 将label添加到scrollView中
            scrollView.addSubview(label)
            // 5. 将label添加到label数组中
            titleLabels.append(label)
            
            // 6. 给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    private func setupBottomLineAndScrollLine(){
        // 1. 添加底线
        let bottomLine:UIView = UIView()
        let lineH:CGFloat = 0.5
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2. 添加滑块
        scrollView.addSubview(scrollLine)
        // 2.1 获取第一个label
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor.orange
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        
    }
}

//MARK: - 监听label点击
extension PageTitleView{
    @objc fileprivate func titleLabelClick(tapGes:UITapGestureRecognizer){
        // 1. 获取当前labal的下标值
        guard let currentLabel = tapGes.view as? UILabel else {return}
        // 2. 获取之前的label
        let oldLabel = titleLabels[currentIndex]
        // 3. 保存 新的label的下标值
        currentIndex = currentLabel.tag
        // 4. 切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        // 5. 滚动条位置改变
        let scrollLineX = currentLabel.frame.origin.x
        UIView.animate(withDuration: 0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        // 6. 通知代理做事情
        delegate?.pageTitleView(titleView: self, selectIndex: currentIndex)
    }
}
//MARK: - 暴露给外部的方法
extension PageTitleView{
    func setTitleWithProgress(progress:CGFloat, sourceIndex:Int, targetIndex:Int){
        // 1. 取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2. 处理滑块逻辑
        let totalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let movx = totalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + movx
        
        // 3. 颜色渐变
        // 3.1 取出颜色变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1-kNormalColor.1, kSelectColor.2-kNormalColor.2);
        // 3.2 变化sourceLabe
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0*progress, g: kSelectColor.1-colorDelta.1*progress, b: kSelectColor.2-colorDelta.2*progress)
        // 3.3 变化tartgetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0*progress, g: kNormalColor.1 + colorDelta.1*progress, b: kNormalColor.2 + colorDelta.2*progress)
        
        // 4. 更改当前index
        currentIndex = targetIndex
    }
}
