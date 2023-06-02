//
//  LoginViewModel.swift
//  Todolist
//
//  Created by Bhavi on 01/06/23.
//

import Foundation
import MagicalRecord
import RxCocoa
import RxSwift

protocol LoginViewModelInputs {
    func login()
}

protocol LoginViewModelOuptput: ActivityIndicatorProtocol {
    var onResult: PublishSubject<Result<Void, ErrorHandler>> { get set }
    var request: Login.Request { get set }
}

protocol LoginViewModelOuptputType {
    var input: LoginViewModelInputs { get set }
    var output: LoginViewModelOuptput { get set }
}

class LoginViewModel: LoginViewModelInputs, LoginViewModelOuptput, LoginViewModelOuptputType {
    var is_animating: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var input: LoginViewModelInputs { get { return self } set {} }
    var output: LoginViewModelOuptput { get { return self } set {} }

    var onResult: PublishSubject<Result<Void, ErrorHandler>> = PublishSubject()
    var request = Login.Request()

    var bag = DisposeBag()

    func login() {
        guard validate() else {
            return
        }
        is_animating.accept(true)
        if DBManager.shared.checkUserExist(email: request.email.value, password: request.password.value) {
            onResult.onNext(.success(()))
        } else {
            DBManager.shared.storeUser(data: request.toRequest()) { [weak self] _ in
                self?.onResult.onNext(.success(()))
            }
        }
    }
}

extension LoginViewModel: ValidatorDelegate {
    func validate() -> Bool {
        guard isValidEmailAddress(email: request.email.value.trim()) else {
            onResult.onNext(.failure(ErrorHandler.generic(.InvalidEmail)))
            return false
        }
        return true
    }
}

enum Login {
    struct Request: RequestType {
        var email: BehaviorRelay<String> = BehaviorRelay(value: "")
        var password: BehaviorRelay<String> = BehaviorRelay(value: "")

        func toRequest() -> [String: Any] {
            let value = email.value.trim()

            let request: [String: Any] = ["email": value,
                                          "password": password.value,
                                          "uuid": UUID().uuidString,
                                          "is_active": true,
                                          "name": value.components(separatedBy: "@").first as Any]
            return request
        }
    }
}
