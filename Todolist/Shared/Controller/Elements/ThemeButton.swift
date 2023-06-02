import RxRelay
import RxSwift
import UIKit

enum ThemeButtonType {
    case normal
    case with(UIImage)
    case textWith(UIImage)
    case theme_color(Bool, CGFloat)
    case roundCorner(UIColor, fontclr: UIColor)
}

class ThemeButton: UIButton, ActivityIndicatorProtocol {
    var is_animating: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isSelectedBinder = BehaviorRelay<Bool>(value: true)

    var bottomBorder: CALayer?
    var activityIndicator: UIActivityIndicatorView!
    private var originalButtonText: String?
    private var originalImage: UIImage?

    private var shadowLayer: CAShapeLayer!
    var bag = DisposeBag()
    var type: ThemeButtonType = .normal {
        didSet {
            theme(with: type)
        }
    }

    func showLoading(indicatorColor: UIColor = UIColor.white) {
        originalButtonText = titleLabel?.text
        originalImage = imageView?.image
        setTitle("", for: .normal)
        setImage(nil, for: .normal)

        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
            activityIndicator.color = indicatorColor
        }

        showSpinning()
    }

    func hideLoading() {
        setTitle(originalButtonText, for: .normal)
        setImage(originalImage, for: .normal)

        if activityIndicator != nil {
            activityIndicator.stopAnimating()
        }
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        addConstraint(yCenterConstraint)
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        if title?.isEmpty != true && title != nil {
            originalButtonText = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        originalButtonText = titleLabel?.text
        theme(with: type)
        is_animating.skip(1).bind(onNext: { [weak self] value in
            value ? self?.showLoading(indicatorColor: .white) : self?.hideLoading()
        }).disposed(by: bag)
    }

    func theme(with type: ThemeButtonType) {
        switch type {
        case .normal:
            layer.cornerRadius = frame.height / 2
            layer.masksToBounds = true
            titleLabel?.font = AppFont.medium.size(16)
            setTitleColor(Asset.Colors.white.color, for: .normal)
            backgroundColor = .white
            setImage(UIImage(), for: .normal)
            addShadow()

        case let .with(image):
            layer.cornerRadius = 16
            layer.masksToBounds = true
            setTitleColor(.white, for: .normal)
            backgroundColor = Asset.Colors.plusbg.color
            setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            tintColor = UIColor.black
            setTitle("", for: .normal)
            addShadow()
            setNeedsDisplay()
        case let .theme_color(inverted, fontpoint):
            layer.cornerRadius = frame.height / 2
            layer.masksToBounds = true
            contentEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
            titleLabel?.font = AppFont.medium.size(fontpoint)
            tintColor = .clear
            if inverted {
                layer.borderWidth = 1
                layer.borderColor = Asset.Colors.border.color.cgColor
                backgroundColor = .white
                setTitleColor(Asset.Colors.btnbg.color, for: .normal)
            } else {
                layer.borderWidth = 0
                backgroundColor = Asset.Colors.btnbg.color
                setTitleColor(Asset.Colors.white.color, for: .normal)
            }
            addShadow()
        case let .roundCorner(color, fontclr: fcolor):
            titleLabel?.font = AppFont.bold.size(14, family_Name: roboto)
            layer.cornerRadius = frame.height / 2
            layer.masksToBounds = true
            contentEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
            tintColor = .clear
            layer.borderWidth = 0
            backgroundColor = color
            setTitleColor(fcolor, for: .normal)
            addShadow()
        case let .textWith(image):
            layer.cornerRadius = 5
            layer.masksToBounds = true
            titleLabel?.font = AppFont.medium.size(14, family_Name: roboto)
            setTitleColor(Asset.Colors.black.color, for: .normal)
            backgroundColor = .white
            layer.borderWidth = 1
            tintColor = Asset.Colors.txtTitleLabel.color
            setImage(image, for: .normal)
            layer.borderColor = Asset.Colors.border.color.cgColor
            let valL = 15.0
            imageEdgeInsets = UIEdgeInsets(top: 0, left: valL, bottom: 0, right: 0)
        }
    }


    func addShadow() {
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
    }

    func setRound() {
        layoutIfNeeded()
        layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        clipsToBounds = true
    }
}

extension UIButton {
    func roundedButton() {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft, .bottomRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
