import CoreData
import DateHelper
import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON
import UIKit

extension UIApplication {
    public static func setRootView(_ viewController: UIViewController,
                                   options: UIView.AnimationOptions = .transitionCrossDissolve,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.5,
                                   completion: (() -> Void)? = nil) {
        guard animated else {
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = viewController
            return
        }

        UIView.transition(with: UIApplication.shared.windows.filter { $0.isKeyWindow }.first!, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }

    static var appVersion: String {
        guard let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return ""
        }
        return appVersion
    }

    static var appBuild: String {
        guard let appBuild = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return ""
        }
        return appBuild
    }
}

extension UIViewController {
    func nameWithDeinit() {
        print("De-init callled :::::::::::::" + String(describing: type(of: self)))
    }

    @objc open func cancelClick(_ sender: AnyObject?) {
        dismiss(animated: true, completion: { () in

        })
    }

    @objc open func backClick(_ sender: AnyObject?) {
        navigationController?.popViewController(animated: true)
    }

    var topbarHeight: CGFloat {
        return (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20) +
            (navigationController?.navigationBar.frame.height ?? 44)
    }
}

extension String {
    /// Apply strike font on text
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length))

        return attributeString
    }
}

extension Date {
    public func getOnlyTimeWithAMPMwithoutzero() -> String! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: self)
        return date
    }

    func getDateFromString() -> String {
        if compare(.isThisWeek) {
            if compare(.isToday) {
                return "Today"
            } else {
                return dayOfWeek() ?? ""
            }
        } else {
            return toString(format: DateFormat.time_ampm) ?? ""
        }
    }

    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

extension Array where Element == String? {
    func compactConcate(separator: String) -> String {
        return compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: separator)
    }
}

extension Sequence where Element: Hashable {
    func unique() -> [Element] {
        NSOrderedSet(array: self as! [Any]).array as! [Element]
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String {
    // Remove leading spaces / trim spaces of UITextField / UITextView
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

extension String {
    static let InvalidEmail = NSLocalizedString("Invalid email address.", comment: "")
    static let InvalidPhone = NSLocalizedString("Invalid phone number.", comment: "")
    static let ShorterPassword = NSLocalizedString("Password should contain at least 8 characters, including: special character, numbers, lower and upper case letters.", comment: "")
    static let emptyString = NSLocalizedString("Please enter the vale.", comment: "")
    static let passwordNotMatch = NSLocalizedString("New password and confirm password does not match", comment: "")
}

extension UIButton {
    func setSelected(isSelected: Bool) {
        let image: UIImage = isSelected ? Asset.Assets.icChecked.image : Asset.Assets.icUncheck.image
        setImage(image, for: .normal)
    }
}

extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0

        return String(format: "#%06x", rgb)
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool) {
        if indexPathsForVisibleRows?.isEmpty == false {
            let indexPath = IndexPath(
                row: numberOfRows(inSection: numberOfSections - 1) - 1,
                section: numberOfSections - 1)
            scrollToRow(at: indexPath, at: .bottom, animated: animated)
            // self.scrollRectToVisible(self.rectForRow(at: indexPath), animated: animated)
            // self.isHidden = false
        }
    }

    func scrollToBottomNew(animated: Bool) {
        let y = contentSize.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }

    func scrollToTop(animated: Bool) {
        if indexPathsForVisibleRows?.isEmpty == false {
            let indexPath = IndexPath(row: 0, section: 0)
            scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }

    func setBottomInset(with size: CGFloat) {
        let current = contentInset
        contentInset = UIEdgeInsets(top: current.top, left: current.left, bottom: size, right: current.right)
        scrollIndicatorInsets = UIEdgeInsets(top: current.top, left: current.left, bottom: size, right: current.right)
    }

    func hk_setEmptySepratorFooter(color: UIColor = UIColor.groupTableViewBackground) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        view.backgroundColor = color
        tableFooterView = view
    }
}

extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + 10)
        setContentOffset(bottomOffset, animated: false)
    }
}

extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }

    var currentDateRange: (dateFrom: Date?, dateTo: Date?) {
        // Get the current calendar with local time zone
        let calendar = Calendar.current
        //        calendar.timeZone = NSTimeZone.local

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: self) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
        return (dateFrom, dateTo)
    }

    var currentTime: Date? {
        // Get the current calendar with local time zone
        _ = Calendar.current

        guard let strTime = toString(format: DateFormat.time_ampm) else { return Date() }
        let timeDate = Date(fromString: strTime, format: DateFormat.time_ampm)

        return (timeDate)
    }

    func dateComponentsSince(date: Date, components: Set<Calendar.Component>?) -> DateComponents {
        let components = components ?? Set<Calendar.Component>([.nanosecond, .second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: date, to: self)
        return differenceOfDate
    }

    func timeStringSince(date: Date, components: Set<Calendar.Component>? = nil) -> String {
        let differenceOfDate = dateComponentsSince(date: date, components: components)
        return differenceOfDate.dateComponentsToTimeString()
    }
}

extension DateComponents {
    func dateComponentsToTimeString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumIntegerDigits = 2

        let minute = formatter.string(from: self.minute! as NSNumber)!
        let second = formatter.string(from: self.second! as NSNumber)!

        let str = "\(minute):\(second)"
        return str
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension UIView {
    func roundCorners(cornerRadius: Double) {
        layer.cornerRadius = CGFloat(cornerRadius)
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func loginRoundCorner(cornerRadius: Double) {
        layer.cornerRadius = CGFloat(cornerRadius)
        clipsToBounds = true
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }

    func roundCornersBottom(cornerRadius: Double) {
        layer.cornerRadius = CGFloat(cornerRadius)
        clipsToBounds = true
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func roundAllCorners(cornerRadius: Double) {
        layer.cornerRadius = CGFloat(cornerRadius)
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}

extension UIView {
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: size).cgPath // 1
        shadowLayer.path = cgPath // 2
        shadowLayer.fillColor = fillColor.cgColor // 3
        shadowLayer.shadowColor = shadowColor.cgColor // 4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet // 5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        layer.insertSublayer(shadowLayer, at: 0)
    }

    func applyPulse(_ apply: Bool = true) {
        if apply {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = 1.5
            animation.duration = 0.8
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            layer.add(animation, forKey: "pulsing")
        } else {
            layer.removeAnimation(forKey: "pulsing")
        }
    }

    func blink(_ apply: Bool = true) {
        if apply {
            alpha = 0.0
            UIView.animate(withDuration: 0.8,
                           delay: 0.0,
                           options: [.curveEaseInOut, .autoreverse, .repeat],
                           animations: { [weak self] in self?.alpha = 1.0 },
                           completion: { [weak self] _ in self?.alpha = 0.0 })
        } else {
            alpha = 1.0
        }
    }
}

extension Date {
    func compareTimeOnly(to: Date) -> ComparisonResult {
        let calendar = Calendar.current
        let components2 = calendar.dateComponents([.hour, .minute, .second], from: to)
        let date3 = calendar.date(bySettingHour: components2.hour!, minute: components2.minute!, second: components2.second!, of: self)!

        let seconds = calendar.dateComponents([.second], from: self, to: date3).second!
        if seconds == 0 {
            return .orderedSame
        } else if seconds > 0 {
            // Ascending means before
            return .orderedAscending
        } else {
            // Descending means after
            return .orderedDescending
        }
    }

    func equalToDate(dateToCompare: NSDate) -> Bool {
        // Declare Variables
        var isEqualTo = false

        // Compare Values
        if compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }

        // Return Result
        return isEqualTo
    }
}

extension Data {
    var uint8: UInt8 {
        withUnsafeBytes { $0.load(as: UInt8.self) }
    }
}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}

extension UITextView {
    private class PlaceholderLabel: UILabel {}

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap({ $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap({ $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height + 10
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
            placeholderLabel.textColor = .lightGray

            // textStorage.delegate = self
        }
    }
}

extension NSFetchedResultsController {
    /// Check whether provided indexPath is valid.
    ///
    /// - note: This method checks if self.section is greater than indexPath.section
    /// and if number of object in indexPath.section is greater than indexPath.row
    ///
    /// - parameter indexPath: indexPath to be checked.
    ///
    /// - returns: Whether indexPath has a value associated to it.
    @objc private func hasObject(at indexPath: IndexPath) -> Bool {
        guard let sections = sections, sections.count > indexPath.section else {
            return false
        }

        let sectionInfo = sections[indexPath.section]

        guard sectionInfo.numberOfObjects > indexPath.row else {
            return false
        }

        return true
    }

    /// Check whether the object exists and returns it if true.
    ///
    /// - parameter indexPath: Indexpath of object.
    ///
    /// - returns: Object at indexPath if exists. Nil otherwise.
    @objc func safeObject(at indexPath: IndexPath) -> NSManagedObject? {
        guard hasObject(at: indexPath) else {
            return nil
        }
        return object(at: indexPath) as? NSManagedObject
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension String {
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
}

extension Locale {
    static var preferredLanguageCode: String {
        let defaultLanguage = "en"
        let preferredLanguage = preferredLanguages.first ?? defaultLanguage
        return Locale(identifier: preferredLanguage).languageCode ?? defaultLanguage
    }

    static var preferredLanguageCodes: [String] {
        return Locale.preferredLanguages.compactMap({ Locale(identifier: $0).languageCode })
    }
}

extension CALayer {
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}

extension CGRect {
    func createCorners() -> CGPath {
        // Calculate the length of corner to be shown
        let cornerLengthToShow = size.height * 0.10

        // Create Paths Using BeizerPath for all four corners
        let topLeftCorner = UIBezierPath()
        topLeftCorner.move(to: CGPoint(x: minX, y: minY + cornerLengthToShow))
        topLeftCorner.addLine(to: CGPoint(x: minX, y: minY))
        topLeftCorner.addLine(to: CGPoint(x: minX + cornerLengthToShow, y: minY))

        let topRightCorner = UIBezierPath()
        topRightCorner.move(to: CGPoint(x: maxX - cornerLengthToShow, y: minY))
        topRightCorner.addLine(to: CGPoint(x: maxX, y: minY))
        topRightCorner.addLine(to: CGPoint(x: maxX, y: minY + cornerLengthToShow))

        let bottomRightCorner = UIBezierPath()
        bottomRightCorner.move(to: CGPoint(x: maxX, y: maxY - cornerLengthToShow))
        bottomRightCorner.addLine(to: CGPoint(x: maxX, y: maxY))
        bottomRightCorner.addLine(to: CGPoint(x: maxX - cornerLengthToShow, y: maxY))

        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: CGPoint(x: minX, y: maxY - cornerLengthToShow))
        bottomLeftCorner.addLine(to: CGPoint(x: minX, y: maxY))
        bottomLeftCorner.addLine(to: CGPoint(x: minX + cornerLengthToShow, y: maxY))

        let combinedPath = CGMutablePath()
        combinedPath.addPath(topLeftCorner.cgPath)
        combinedPath.addPath(topRightCorner.cgPath)
        combinedPath.addPath(bottomRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)

        return combinedPath
    }
}
