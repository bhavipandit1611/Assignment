//
//  AddTodoTest.swift
//  TodolistTests
//
//  Created by Bhavi on 02/06/23.
//

import Nimble
import XCTest

@testable import Todolist

final class AddTodoTest: XCTestCase {
    enum Result: Equatable {
        case success
        case failed
    }

    enum TestCase: String {
        case added
        case failure
    }

    private var todoExpectaion: XCTestExpectation!
    var viewModel: TodoTaskViewModelOuptputType!
    var result: Result = .failed

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func setController() {
        viewModel = TodoTaskViewModel()
        let addTodoController = StoryboardScene.Tasks.sidAddTask.instantiate()
        addTodoController.viewModel = viewModel
        addTodoController.loadViewIfNeeded()
    }

    func testAddTaskSuccess() {
        todoExpectaion = expectation(description: TestCase.added.rawValue)
        viewModel.output.request.taskTitle.accept("Task 1")
        viewModel.output.request.dateTime.accept(Date().toString(format: DateFormat.month_date_time_ampm_format) ?? "")
        viewModel.input.addTask()
        waitForExpectations(timeout: 30)
        viewModel.output.onResult.onNext(.success(()))
        expect(self.result).to(equal(.success))
        todoExpectaion = nil
    }
}
