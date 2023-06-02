import CoreData
import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol BasicEnumType {
    var title: String { get }
    var image: UIImage? { get }
}

protocol BasicSetupType {
    func setUpText()
    func setUpViews()
    func themeSetUp()
    func bindData()
}

extension BasicSetupType {
    func bindData() {}
    func themeSetUp() {}
}

extension BasicEnumType {
    var image: UIImage? {
        return nil
    }
}

protocol ActivityIndicatorProtocol {
    var is_animating: BehaviorRelay<Bool> { get set }
}

protocol ActivityIndicatorUpdateProtocol {
    var is_animating_Update: BehaviorRelay<Bool> { get set }
}

protocol ActivityIndicatorRemoveProtocol {
    var is_animating_delete: BehaviorRelay<Bool> { get set }
}

protocol ActivityIndicatorFetchProtocol {
    var is_animating_fetch: BehaviorRelay<Bool> { get set }
}

protocol RequestType {
    func toRequest() -> [String: Any]
}

protocol ErrorHandlerProtocol {
    func onError(_ error: ErrorHandler)
    func onValidationError(_ error: ValidaterError)
    func onCustomError(_ error: ErrorHandler)
}

extension ErrorHandlerProtocol {
    func onValidationError(_ error: ValidaterError) {}
    func onCustomError(_ error: ErrorHandler) {}
}

protocol CleanObjectsData {
    static func clear(data: Any, context: NSManagedObjectContext)
}

protocol UserLogic {
    var user_id: String? { get set }
    var name: String? { get set }
}

enum ErrorHandler: Error {
    case no_connection
    case request_time_out
    case request_cancelled
    case server_issue(String?)
    case generic(String)

    var message: String {
        switch self {
        case .request_time_out:
            return "We are unable to connect with server, please try again later."
        case let .server_issue(message):
            return message ?? "We are unable to connect with server, please try again later."
        case let .generic(message):
            return message
        case .no_connection:
            return "Sorry there appears to be a problem with your internet connection, please try again later."
        default:
            return "Your request has been cancelled."
        }
    }
}

extension Error {
    var error_handler: ErrorHandler {
        guard let error = self as? ErrorHandler else { return .server_issue(localizedDescription) }
        return error
    }
}
