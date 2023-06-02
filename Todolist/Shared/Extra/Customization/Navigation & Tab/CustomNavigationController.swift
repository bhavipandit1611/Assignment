import UIKit

open class CustomNavigationController: UINavigationController {

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    open override var shouldAutorotate: Bool {
        return true
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        return [UIInterfaceOrientationMask.portraitUpsideDown, UIInterfaceOrientationMask.portrait]
    }
}
