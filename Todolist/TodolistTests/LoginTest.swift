//
//  LoginTest.swift
//  TodolistTests
//
//  Created by Bhavi on 02/06/23.
//

import Nimble
import XCTest

@testable import Todolist

final class LoginTest: XCTestCase {
    enum Result: Equatable {
        case success
        case failed
        case notValid
    }

    enum TestCase: String {
        case loggedin
        case failure
        case notConfirmed
    }

    private var loginExpectaion: XCTestExpectation!

    var viewModel: LoginViewModelOuptputType!

    var result: Result = .failed

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func setController() {
        viewModel = LoginViewModel()
        let navController = StoryboardScene.Main.initialScene.instantiate()
        let loginController = (navController.viewControllers.first as? LoginViewC)
        loginController?.viewModel = viewModel
        loginController?.loadViewIfNeeded()
    }

    func testLoginSuccess() {
        loginExpectaion = expectation(description: TestCase.loggedin.rawValue)
        viewModel.output.request.email.accept("bhavi@yopmail.com")
        viewModel.output.request.password.accept("Qwerty")
        viewModel.input.login()
        waitForExpectations(timeout: 30)
        viewModel.output.onResult.onNext(.success(()))
        loginSuccess()
        expect(self.result).to(equal(.success))
        loginExpectaion = nil
    }

    func testLoginFailure() {
        loginExpectaion = expectation(description: TestCase.failure.rawValue)
        viewModel.output.request.email.accept("fake.shah@softvan")
        viewModel.output.request.password.accept("Q1werty")
        viewModel.input.login()
        waitForExpectations(timeout: 30)
        expect(self.result).to(equal(.failed))
    }
}

extension LoginTest {
    func loginSuccess() {
        result = .success
        loginExpectaion.fulfill()
    }

    func onError(_ error: ErrorHandler) {
        result = .failed
        loginExpectaion.fulfill()
    }
}
