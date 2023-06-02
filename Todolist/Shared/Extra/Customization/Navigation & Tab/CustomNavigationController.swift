import UIKit

open class CustomNavigationController: UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override open var shouldAutorotate: Bool {
        return true
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portraitUpsideDown, UIInterfaceOrientationMask.portrait]
    }
}
