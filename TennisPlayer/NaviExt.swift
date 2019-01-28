import UIKit

//自定义导航控制条的字体颜色
extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
