//
//  HYKEmooticonCollectionView.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/3/13.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HYKEmoticonCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = self.bounds.size
        
        layout.scrollDirection = .Horizontal
        
        layout.minimumInteritemSpacing = 0
        
        layout.minimumLineSpacing = 0
        
        super.layoutSubviews()
    }
    
    private func setupUI(){
        
        backgroundColor = UIColor.clearColor()
        
        showsHorizontalScrollIndicator = false//水平滚动
        
        pagingEnabled = true//分页
        
        bounces = false//弹簧
        
    }
}
