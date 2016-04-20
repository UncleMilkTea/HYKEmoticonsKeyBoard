//
//  Emoticons.swift
//
//  Created by 侯玉昆 on 16/3/13.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HYKEmoticons: NSObject ,NSCoding{

    // 表情的文字描述
    var chs: String?
    /// 表情图片的名字
    var png: String?
    /// 表情类型,如果为1代表是Emoji表情,为0代表是图片表情
    var type: String?
    /// Emoji表情对应的code
    var code: String?
    /// 该表情所在的文件夹名字
    var folderName: String?

    init(dic:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}

    ///归档的方法
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(chs,forKey: "chs")
        encoder.encodeObject(png,forKey: "png")
        encoder.encodeObject(type,forKey: "type")
        encoder.encodeObject(code,forKey: "code")
        encoder.encodeObject(folderName,forKey: "folderName")
        
    }
    ///解档的方法
    required init?(coder decoder: NSCoder) {
        
        chs = decoder.decodeObjectForKey("chs") as? String
        png = decoder.decodeObjectForKey("png") as? String
        type = decoder.decodeObjectForKey("type") as? String
        code = decoder.decodeObjectForKey("code") as? String
        folderName = decoder.decodeObjectForKey("folderName") as? String
        
    }
}
