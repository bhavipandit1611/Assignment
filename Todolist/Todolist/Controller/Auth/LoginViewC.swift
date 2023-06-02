//
//  LoginViewC.swift
//  Todolist
//
//  Created by Bhavi on 01/06/23.
//

import RxSwift
import UIKit

class LoginViewC: BaseController {
    @IBOutlet var btnLogin: ThemeButton!
    @IBOutlet var txtEmail: TitledTextField!
    @IBOutlet var txtPassword: TitledTextField!

    var viewModel: LoginViewModelOuptputType = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpText()
        setUpViews()
        bindData()
    }
}

extension LoginViewC: BasicSetupType {
    func setUpText() {
        title = "Login"
        btnLogin.setTitle("Login with register", for: .normal)
        txtEmail.titleLabelText = "Email"
        txtPassword.titleLabelText = "Password"
        setupAccessbilityIds()
    }

    func setUpViews() {
        btnLogin.type = .roundCorner(Asset.Colors.btnbg.color, fontclr: .white)

        txtEmail.keyboardType = .emailAddress
        txtPassword.returnKeyType = .go
        txtEmail.textContentType = UITextContentType.emailAddress
        txtPassword.textContentType = UITextContentType.password
        txtPassword.isSecureTextEntry = true

        themeSetUp()
    }

    func themeSetUp() {
    }

    func setupAccessbilityIds() {
        btnLogin.isAccessibilityElement = true
        btnLogin.accessibilityIdentifier = "btnLogin"
        txtEmail.isAccessibilityElement = true
        txtEmail.accessibilityIdentifier = "txtEmail"
        txtPassword.isAccessibilityElement = true
        txtPassword.accessibilityIdentifier = "txtPassword"
    }

    func bindData() {
        txtEmail
            .rx.text.orEmpty
            .bind(to: viewModel.output.request.email)
            .disposed(by: disposeBag)

        txtPassword
            .rx.text.orEmpty
            .bind(to: viewModel.output.request.password)
            .disposed(by: disposeBag)

        viewModel.output.onResult.bind(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIApplication.setRootView(StoryboardScene.Tasks.initialScene.instantiate())
            case let .failure(err):
                // TODO: Display Alert
                self.alertError(error: err)
            }
        }).disposed(by: disposeBag)

        btnLogin.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            view.endEditing(true)
            viewModel.input.login()
        }).disposed(by: disposeBag)

        Observable
            .combineLatest(txtEmail
                .rx.text.orEmpty, txtPassword.rx.text.orEmpty)
            .map({ $0.isEmpty || $1.isEmpty })
            .bind(to: btnLogin.rx.hk_disableWithAlpha)
            .disposed(by: disposeBag)
    }
}
