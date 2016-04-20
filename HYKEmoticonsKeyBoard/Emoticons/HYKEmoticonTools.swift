//
//  HYKEmoticonTools.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/3/13.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

let EveryPageCount = 20

class HYKEmoticonTools: NSObject {
    
    /// 单例对象并且屏蔽init方法创建对象
    static let sharedEmoticonTools:HYKEmoticonTools = HYKEmoticonTools()
    private override init() {}
    
    lazy var emoticonsBoundle:NSBundle = {
        
        let path = NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil)
        
        let boundle = NSBundle(path: path!)
        
        return boundle!
        }()
    
    /// 最近表情
    lazy var recentEmoticons:[HYKEmoticons] = {
        
        // 从文件里面读取最近表情
        if let result = NSKeyedUnarchiver.unarchiveObjectWithFile(self.recentEmoPath) as? [HYKEmoticons]{
            
            return result // 如果有值并且值是 [HMEmotion] 类型的话就直接返回
        }
        
        return [HYKEmoticons]()
    }()
    
    /// 默认表情
    lazy var defaultEmoticions:[HYKEmoticons] = {
        
        return self.emoticonsWithFolderName("default")
        }()
    
    // Emoji表情
    lazy var emojiEmoticons: [HYKEmoticons] = {
        return self.emoticonsWithFolderName("emoji")
        }()
    
    /// 浪小花表情
    lazy var lxhEmoticons: [HYKEmoticons] = {
        return self.emoticonsWithFolderName("lxh")
        }()
    
    /// collectionView 所有的表情数据
    lazy var allEmoticon: [[[HYKEmoticons]]] = {
        return [
            [self.recentEmoticons],
            self.typeEmoticonPage(self.defaultEmoticions),
            self.typeEmoticonPage(self.emojiEmoticons),
            self.typeEmoticonPage(self.lxhEmoticons)
        ]
        }()
    
    /// 最近表情的保存路径
    private lazy var recentEmoPath:String = String ((NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("recent.archive"))
    
    ///返回某种表情二维数组
    private func typeEmoticonPage(emoticons:[HYKEmoticons])->[[HYKEmoticons]]{
        
        //定义一个零时数组
        var array:[[HYKEmoticons]] = [[HYKEmoticons]]()
        //计算共有几页
        let pageCount = (emoticons.count-1)/EveryPageCount + 1
        //遍历页数,截取对应的表情数组
        for i in 0..<pageCount {
            //计算截取的位置
            let loc = i * EveryPageCount
            //计算截取的长度
            var len = EveryPageCount
            
            if loc + len > emoticons.count{
                
                len = emoticons.count - loc
            }
            let range = NSMakeRange(loc, len)
            
            let subArray = (emoticons as NSArray).subarrayWithRange(range) as! [HYKEmoticons]
            
            //再把截取出来的数组放到一个数组里去
            array.append(subArray)
        }
        return array
    }
    
    // 读取表情的方法
    private func emoticonsWithFolderName(folderName:String)->[HYKEmoticons]{
        
        let path = self.emoticonsBoundle.pathForResource("\(folderName)/info.plist", ofType: nil)!
        
        let tempArray = NSArray(contentsOfFile: path)!
        
        var array = [HYKEmoticons]()
        
        for value in tempArray {
            
            let model = HYKEmoticons(dic: (value as! [String:AnyObject]))
            //记录表情数据文件夹的名字
            model.folderName = folderName
            
            array.append(model)
        }
        return array
    }
    /// 最近表情按钮的保存
    func saveRencentEmoticons(emoticons:HYKEmoticons){
        
        //表情过滤,相同表情不保存
        let result = recentEmoticons.filter {
        
        $0.type == "0" ? $0.png == emoticons.png : $0.code == emoticons.code
        
        }
        for value in result {
            let index = recentEmoticons.indexOf(value)!
            recentEmoticons.removeAtIndex(index)
        }
        //把最近表情添加到数组
        recentEmoticons.insert(emoticons, atIndex: 0)
        
        while recentEmoticons.count > 20 {
            
          recentEmoticons.removeLast() //数组不能一边遍历一边移除
           
        }
        // 数组归档
        NSKeyedArchiver.archiveRootObject(recentEmoticons, toFile: recentEmoPath)
        
        allEmoticon[0][0] = recentEmoticons //更新表情数据
    }
    
    /// 通过表情字符串,去查找其对应的表情模型
    func emoticonsWithChs(chs:String)->HYKEmoticons?{
        
        // 1. 从默认里面取
        let defaultResults = defaultEmoticions.filter { (emoticon) -> Bool in
            if emoticon.chs == chs {
                return true
            }
            return false
        }
        
        if defaultEmoticions.count>0{
            
            return defaultResults.first
        }
        
        // 2. 从浪小花里面取
        let lxhResults = lxhEmoticons.filter { (emoticon) -> Bool in
            if emoticon.chs == chs {
                return true
            }
            return false
        }
        
        if lxhResults.count > 0 {
            return lxhResults.first
        }
        
        return nil
    }
    
}
