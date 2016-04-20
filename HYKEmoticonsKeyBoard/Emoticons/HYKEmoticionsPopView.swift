//
//  HYKEmoticionsPopView.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/3/14.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HYKEmoticionsPopView: UIView {

    @IBOutlet weak var emoticionBtn: HYKEmoticionsButton!
    
    class func popView()->HYKEmoticionsPopView{
        
        return NSBundle.mainBundle().loadNibNamed("HYKEmoticionsPopView", owner: nil, options: nil).last! as! HYKEmoticionsPopView
    }

}
