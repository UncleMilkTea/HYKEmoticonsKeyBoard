//
//  HYKEmoticionsButton.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/3/14.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HYKEmoticionsButton: UIButton {

    var emoticions:HYKEmoticons?{
        didSet{
            
            if emoticions?.type == "0" {
                
                let image = UIImage(named: "\(emoticions!.folderName!)/\(emoticions!.png!)", inBundle: HYKEmoticonTools.sharedEmoticonTools.emoticonsBoundle, compatibleWithTraitCollection: nil)
                
                self.setImage(image, forState: .Normal)
                
                self.setTitle(nil, forState: .Normal)
            }else{
                
                let title = (emoticions!.code! as NSString).emoji()
                
                self.setTitle(title, forState: .Normal)
                
                self.setImage(nil, forState: .Normal)
            }
        }
    }
}
