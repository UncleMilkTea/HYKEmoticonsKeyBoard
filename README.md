# HYKEmoticonsKeyBoard
表情键盘(swift)

- emoji表情解析
- 最近表情归档存储
- 表情已经打包
- 手势识别和坐标转换
- collectionView布局表情
- 本表情键盘使用原生约束可以替换为SnapKit

#Picture

![](/录屏.gif)

## TODO

- 支持emoji表情
- 支持图片表情
- 支持图文混排
- 支持系统键盘替换
- 在控制器加入如下代码或者直接替换系统键盘


/*
override func viewDidLoad() {
super.viewDidLoad()

textView.inputView = emoticionsKeyBoard

///监听表情按钮点击通知
NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.emoticonButtonClick(_:)), name: EmoticionsClickBtn, object: nil)
///监听删除表情点击通知
NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardDelDidSelected), name: KeyboardDelDidSelectedNotification, object: nil)

}

//MARK: - 监听表情点击
@objc private func emoticonButtonClick(noti:NSNotification){

textView.insertEmoticiond(noti.userInfo!["emoticions"]! as! HYKEmoticons)
}
//MARK: - 监听表情键盘的删除按钮
@objc private func keyboardDelDidSelected(){

textView.deleteBackward()
}

//MARK: - 懒加载表情键盘
private lazy var emoticionsKeyBoard:HYKEmoticionsView = HYKEmoticionsView(frame: CGRect(x: 0, y: 0, width: SCREENW, height: 228))
*/

## Author

Weibo:[@老实人要刨你家祖坟了](http://weibo.com/caoeggs) 
Github:[houyukun](https://github.com/houyukun) 