import Foundation
import UIKit

@objc(Task)
open class Task: _Task {
    // Custom logic goes here.
}

enum TaskStatus: Int {
    case exceed = 0
    case inprogress
    case upcoming
    case completed
    case delete

    var title: String? {
        switch self {
        case .exceed:
            return "Pending"
        default: return nil
        }
    }

    var txtcolor: UIColor {
        switch self {
        case .exceed:
            return Asset.Colors.red.color
        default: return Asset.Colors.title.color
        }
    }

    var subColor: UIColor {
        return Asset.Colors.subtitle.color
    }
}
