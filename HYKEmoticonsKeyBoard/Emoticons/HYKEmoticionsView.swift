//
//  HYKEmoticions.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/3/12.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

let EmoticionsIdentifier = "EmoticionsIdentifier"

let EmoticionsClickBtn = "EmoticionsClickBtn"

let KeyboardDelDidSelectedNotification = "KeyboardDelDidSelectedNotification"

class HYKEmoticionsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        addSubview(toolBarView)
        addSubview(collectionView)
        addSubview(pageControl)
        
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        toolBarView.superview!.addConstraints([NSLayoutConstraint.init(item: toolBarView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0),NSLayoutConstraint.init(item: toolBarView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0),NSLayoutConstraint.init(item: toolBarView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)])
        
        collectionView.superview!.addConstraints([NSLayoutConstraint.init(item: collectionView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0),NSLayoutConstraint.init(item: collectionView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0),NSLayoutConstraint.init(item: collectionView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0),NSLayoutConstraint.init(item: collectionView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBarView, attribute: .Top, multiplier: 1, constant: 0)])
        
        pageControl.superview!.addConstraints([NSLayoutConstraint.init(item: pageControl, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0),NSLayoutConstraint.init(item: pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: collectionView, attribute: .Bottom, multiplier: 1, constant: 0)])
        
        
//        toolBarView.snp_makeConstraints { (make) -> Void in
//            make.leading.trailing.bottom.equalTo(self)
//        }
//        collectionView.snp_makeConstraints { (make) -> Void in
//            make.leading.top.trailing.equalTo(self)
//            make.bottom.equalTo(toolBarView.snp_top)
//        }
//        pageControl.snp_makeConstraints { (make) -> Void in
//            make.centerX.equalTo(self)
//            make.bottom.equalTo(collectionView)
//        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1), atScrollPosition: .Left, animated:false)
            
            self.toolBarView.selectButtonSection(NSIndexPath(forItem: 0, inSection: 1).section)
        }
    }
    
    ///显示当前页面的个数
    private func setPageControl(indexPath:NSIndexPath){
        
        pageControl.numberOfPages = HYKEmoticonTools.sharedEmoticonTools.allEmoticon[indexPath.section].count
        
        pageControl.currentPage = indexPath.item
        
        pageControl.hidden = indexPath.section == 0
    }
//MARK: - 懒加载
    /// 懒加载toolBar
    private lazy var toolBarView: HYKEmoticionsToolBar = {
        let toolBar = HYKEmoticionsToolBar(frame: CGRectZero)
        
        toolBar.delegate = self
        
        return toolBar
    }()
    
    /// 懒加载collectionView
    private lazy var collectionView:HYKEmoticonCollectionView = {
        
        let collection = HYKEmoticonCollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.dataSource = self
        
        collection.delegate = self
        collection.registerClass(HYKEmoticionsViewCell.self, forCellWithReuseIdentifier: EmoticionsIdentifier)
        
        return collection
        }()
    
    private lazy var pageControl:UIPageControl = {
        
        let page = UIPageControl()
        
        page.userInteractionEnabled = false
        
        page.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        
        page.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKey: "_pageImage")
        
        //page.numberOfPages = 5
        
        return page
    }()
}
//MARK: - 数据源与代理方法
extension HYKEmoticionsView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return HYKEmoticonTools.sharedEmoticonTools.allEmoticon.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return HYKEmoticonTools.sharedEmoticonTools.allEmoticon[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmoticionsIdentifier, forIndexPath: indexPath) as! HYKEmoticionsViewCell
        
        cell.indexPath = indexPath
        
        cell.emoticions = HYKEmoticonTools.sharedEmoticonTools.allEmoticon[indexPath.section][indexPath.item]
        
        return cell
    }
    
    // 监听 collectionView的滚动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    let cells = collectionView.visibleCells()
        
        if cells.count == 2{
            
            let first = cells.first, last = cells.last
            
            let firstRes = abs((first?.frame.origin.x)! - collectionView.contentOffset.x)
            
            let lastRes = abs((last?.frame.origin.x)! - collectionView.contentOffset.x)
            
            let cell = firstRes<lastRes ? first : last
            
            let indexPath = collectionView.indexPathForCell(cell!)!
        
            toolBarView.selectButtonSection(indexPath.section)
            
            setPageControl(indexPath)
        }
    }
}

//MARK: - toolBar代理方法实现表情类型切换
extension HYKEmoticionsView:HYKEmoticionsToolBarDelegate{
    
    func emoticonsToolBar(toolBar: HYKEmoticionsToolBar, type: HYKEmotionType) {
        
        let indexPath = NSIndexPath(forItem: 0, inSection:  type.rawValue)
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
        
        setPageControl(indexPath)
    }
    
}