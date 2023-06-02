import UIKit

class PaddedLabel: UILabel {
    var padding: CGFloat = 6
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width + (padding * 2), height: super.intrinsicContentSize.height)
    }
}

@IBDesignable
class TitledTextField: UITextField {
    @IBInspectable var titleLabelText: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
            setNeedsDisplay()
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return borderLayer.cornerRadius
        }
        set {
            borderLayer.cornerRadius = newValue
            setNeedsDisplay()
        }
    }

    var padding: CGFloat = 14
    var borderWidth: CGFloat = 1
    var borderColor: UIColor = UIColor.gray

    var titleLabel = PaddedLabel()
    let borderLayer = CALayer()

    private let internalPadding: CGFloat = 8

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.prepareForInterfaceBuilder()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.prepareForInterfaceBuilder()
        setup()
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: super.intrinsicContentSize.height + padding)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets(top: internalPadding, left: internalPadding, bottom: internalPadding, right: internalPadding + 8)
        return CGRect(x: internalPadding, y: internalPadding, width: bounds.width, height: bounds.height - internalPadding).inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets(top: internalPadding, left: internalPadding, bottom: internalPadding, right: internalPadding + 8)
        return CGRect(x: internalPadding, y: internalPadding, width: bounds.width, height: bounds.height - internalPadding).inset(by: insets)
    }

    override func draw(_ rect: CGRect) {
        borderLayer.frame = CGRect(x: 0, y: 8, width: frame.width, height: frame.height - 8)
    }

    func setup() {
        borderLayer.backgroundColor = UIColor.white.cgColor
        borderLayer.borderWidth = borderWidth
        borderLayer.frame = CGRect(x: 0, y: 8, width: frame.width, height: frame.height + internalPadding)
        borderLayer.borderColor = borderColor.cgColor
        borderLayer.cornerRadius = 5
        borderLayer.masksToBounds = true
        layer.addSublayer(borderLayer)

        titleLabel.textAlignment = .center
        titleLabel.text = titleLabelText
        titleLabel.font = AppFont.regular.size(12, family_Name: roboto)
        addSubview(titleLabel)
        titleLabel.layer.zPosition = 1
        titleLabel.font = .preferredFont(forTextStyle: .footnote)
        titleLabel.textColor = .gray
        titleLabel.backgroundColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true

        layer.masksToBounds = true
    }
}
