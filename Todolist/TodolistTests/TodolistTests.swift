//
//  TodolistTests.swift
//  TodolistTests
//
//  Created by Bhavi on 01/06/23.
//

import Nimble
import XCTest

@testable import Todolist

final class TodolistTests: XCTestCase {
    enum Result: Equatable {
        case success
        case nodata
    }

    enum TestCase: String {
        case loaded
        case nodata
    }

    private var todoExpectaion: XCTestExpectation!
    var viewModel: TodoTaskViewModelOuptputType!
    var todolistController: TodoListViewC!
    var result: Result = .nodata

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func setController() {
        viewModel = TodoTaskViewModel()
        todolistController = StoryboardScene.Tasks.sidTaskList.instantiate()
        todolistController.viewModel = viewModel
        todolistController.loadViewIfNeeded()
    }

    func testListLoadedTaskSuccess() {
        todoExpectaion = expectation(description: TestCase.loaded.rawValue)
        todolistController.viewDidLoad()
        waitForExpectations(timeout: 30)
        loadedSuccess(count: todolistController.fetchController?.fetchedObjects?.count ?? 0)
        expect(self.result).to(equal(.success))
        todoExpectaion = nil
    }

    func testListNodataTaskSuccess() {
        todoExpectaion = expectation(description: TestCase.loaded.rawValue)
        todolistController.viewDidLoad()
        waitForExpectations(timeout: 30)
        loadedSuccess(count: todolistController.fetchController?.fetchedObjects?.count ?? 0)
        expect(self.result).to(equal(.nodata))
    }

    func loadedSuccess(count: Int) {
        result = count > 0 ? .success : .nodata
        todoExpectaion.fulfill()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
