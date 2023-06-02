import Foundation
import UIKit

enum ValidaterError: Error {
    case invalidData(String)
    var message: String {
        switch self {
        case let .invalidData(message):
            return message
        }
    }
}

protocol ValidatorDelegate {
    func isValidEmailAddress(email: String) -> Bool
    func isValidPassword(password: String?) -> Bool

    func validateString(_ value: String) -> Bool
    func validateInt(_ value: Int) -> Bool
    func validateDouble(_ value: Double) -> Bool
    func predicate(regex: String) -> NSPredicate
}

extension ValidatorDelegate {
    func predicate(regex: String) -> NSPredicate {
        return NSPredicate(format: "SELF MATCHES %@", regex)
    }

    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }

    func isValidPassword(password: String?) -> Bool {
        let regx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\\w\\s]).{8,}$"

        if predicate(regex: regx).evaluate(with: password) {
            return true
        }
        return false
    }

    func isValidURL(url: String) -> Bool {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else { return false }
        return true
    }

    func isValidDecimalNumber(number: String) -> Bool {
        let regx = "^[0-9]\\d*(\\.\\d+)?$"
        if predicate(regex: regx).evaluate(with: number) {
            return true
        }
        return false
    }
}

extension ValidatorDelegate {
    func validateString(_ value: String) -> Bool {
        guard value != "" else {
            return false
        }
        return true
    }

    func validateInt(_ value: Int) -> Bool {
        guard value > 0 else {
            return false
        }
        return true
    }

    func validateDouble(_ value: Double) -> Bool {
        guard value > 0.0 else {
            return false
        }
        return true
    }
}
