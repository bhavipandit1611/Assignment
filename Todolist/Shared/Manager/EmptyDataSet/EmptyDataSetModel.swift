import Foundation
import UIKit

enum EmptyDataSetType {
    case no_data
    case custom_data(String)
    case no_image
    case only_desc(String)
    case custom_all(String, UIImage?, String, String)

    private var fontSize: CGFloat {
        return 20
    }

    var image: UIImage? {
        switch self {
        case .no_image, .only_desc:
            return nil
        case let .custom_all(_, image, _, _):
            return image
        default:
            return nil
        }
    }

    var title: NSAttributedString? {
        switch self {
        case .only_desc:
            return nil
        case let .custom_all(title, _, _, _):
            return NSAttributedString(string: title,
                                      attributes: [NSAttributedString.Key.font: AppFont.medium.size(16), NSAttributedString.Key.foregroundColor: Asset.Colors.black.color])
        default:
            return NSAttributedString(string: "No data available",
                                      attributes: [NSAttributedString.Key.font: AppFont.bold.size(fontSize), NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }

    var desc: NSAttributedString? {
        switch self {
        case let .custom_data(value):
            return NSAttributedString(string: value,
                                      attributes: [NSAttributedString.Key.font: AppFont.regular.size(fontSize - 2), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        case let .only_desc(value):
            return NSAttributedString(string: value,
                                      attributes: [NSAttributedString.Key.font: AppFont.regular.size(fontSize - 2), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        case let .custom_all(_, _, desc, _):
            return NSAttributedString(string: desc,
                                      attributes: [NSAttributedString.Key.font: AppFont.light.size(15), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        default:
            return NSAttributedString(string: "No data available",
                                      attributes: [NSAttributedString.Key.font: AppFont.regular.size(fontSize - 2), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }

    var verticalSpace: CGFloat {
        switch self {
        case .custom_all:
            return 30
        default:
            return 11
        }
    }
}
