import Foundation
import RxCocoa
import RxSwift
import UIKit

extension UIButton {
    public func vs_setDisableWithAlpha(_ isDisable: Bool) {
        if isDisable {
            isEnabled = false
            alpha = 0.9
        } else {
            isEnabled = true
            alpha = 1.0
        }
    }
}

extension Reactive where Base: UIButton {
    public var hk_disableWithAlpha: AnyObserver<Bool> {
        return Binder<Bool>(base) { button, active in
            button.vs_setDisableWithAlpha(active)
        }.asObserver()
    }
}

extension Reactive where Base: UIView {
    public var hk_disableView: AnyObserver<Bool> {
        return Binder<Bool>(base) { view, active in
            if active {
                view.isHidden = true
            } else {
                view.isHidden = false
            }
        }.asObserver()
    }
}

extension Reactive where Base: ThemeButton {
    internal var hk_animating: Binder<Bool> {
        return Binder(base) { button, active in
            if active {
                button.showLoading(indicatorColor: button.titleLabel?.textColor ?? UIColor.white)
            } else {
                button.hideLoading()
            }
        }
    }
}

extension Reactive where Base: ThemeButton {
    internal var setButtonType: Binder<Bool> {
        return Binder(base) { button, active in
            button.type = .theme_color(!active, 13)
        }
    }
}

extension Reactive where Base: UIButton {
    internal var setButtonType: Binder<Bool> {
        return Binder(base) { button, active in
            button.backgroundColor = active ? Asset.Colors.time.color : .clear
        }
    }
}

extension Reactive where Base: UIView {
    internal var hk_userInteraction: Binder<Bool> {
        return Binder(base) { view, active in
            view.isUserInteractionEnabled = !active
        }
    }

    public var hk_disableWithAlpha: AnyObserver<Bool> {
        return Binder<Bool>(base) { view, active in
            if active {
                view.alpha = 0.5
                view.isUserInteractionEnabled = false
            } else {
                view.alpha = 1
                view.isUserInteractionEnabled = true
            }

        }.asObserver()
    }

    public var hk_isHidden: AnyObserver<Bool> {
        return Binder<Bool>(base) { view, active in
            if active {
                view.isHidden = true
            } else {
                view.isHidden = false
            }
        }.asObserver()
    }
}

extension Reactive where Base: UIActivityIndicatorView {
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(base) { activityIndicator, active in
            if active {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}

extension Reactive where Base: BaseController {
    internal var hk_isEmptyDataSetHidden: AnyObserver<Bool> {
        return Binder<Bool>(base) { base, active in
            if !active {
                base.emptyDataSetHandler?.setUpEmptyData()
            } else {
                base.emptyDataSetHandler?.removeEmptyData()
            }

        }.asObserver()
    }
}

extension Reactive where Base: BaseTableController {
    internal var hk_isSkeletonVisible: AnyObserver<Bool> {
        return Binder<Bool>(base) { base, active in
            if active {
                base.fetchController?.delegate = nil
            } else {
                base.fetchController?.delegate = base
                base.performFetch()
                base.tableView.reloadData()
            }
        }.asObserver()
    }
}


extension Reactive where Base: UITextField {
    /// Transforms control property of type `String?` into control property of type `String`.
    public var trim: Observable<String> {
        return value.orEmpty.map { $0.trim() }
    }

    public var emailToUsername: Observable<String> {
        return trim.map { $0.components(separatedBy: "@").first ?? "" }
    }
}

extension UIBarButtonItem {
    public func vs_setDisable(_ isDisable: Bool) {
        if isDisable {
            isEnabled = false
        } else {
            isEnabled = true
        }
    }
}

extension Reactive where Base: UIBarButtonItem {
    public var hk_disable: AnyObserver<Bool> {
        return Binder<Bool>(base) { button, active in
            button.vs_setDisable(active)
        }.asObserver()
    }
}
