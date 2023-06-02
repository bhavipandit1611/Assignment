//
//  TodoTaskViewModel.swift
//  Todolist
//
//  Created by Bhavi on 01/06/23.
//

import Foundation
import MagicalRecord
import RxCocoa
import RxSwift

protocol TodoTaskViewModelInputs {
    func addTask()
    func updateTask()
    func deleteTask(task: ToDolist?)
    func complete(task: ToDolist?)
    func logout()
}

protocol TodoTaskViewModelOuptput {
    var onResult: PublishSubject<Result<Void, ErrorHandler>> { get set }
    var onLogout: PublishSubject<Void> { get set }
    var request: TodoTask.Request { get set }
    var objTask: ToDolist? { get set }
}

protocol TodoTaskViewModelOuptputType {
    var input: TodoTaskViewModelInputs { get set }
    var output: TodoTaskViewModelOuptput { get set }
}

class TodoTaskViewModel: TodoTaskViewModelInputs, TodoTaskViewModelOuptput, TodoTaskViewModelOuptputType {
    var input: TodoTaskViewModelInputs { get { return self } set {} }
    var output: TodoTaskViewModelOuptput { get { return self } set {} }

    var onResult: PublishSubject<Result<Void, ErrorHandler>> = PublishSubject()
    var onLogout: PublishSubject<Void> = PublishSubject()
    var request = TodoTask.Request()
    var objTask: ToDolist?

    var bag = DisposeBag()

    func addTask() {
        DBManager.shared.AddTask(data: request.toRequest()) { [weak self] _ in
            self?.onResult.onNext(.success(()))
        }
    }

    func updateTask() {
        objTask?.task_end_date = Date(detectFromString: request.dateTime.value)
        objTask?.task_title = request.taskTitle.value
        Config.db_context.mr_saveToPersistentStoreAndWait()
        onResult.onNext(.success(()))
    }

    func deleteTask(task: ToDolist?) {
        task?.task_status = (TaskStatus.delete.rawValue) as NSNumber
        Config.db_context.mr_saveToPersistentStoreAndWait()
        onResult.onNext(.success(()))
    }

    func complete(task: ToDolist?) {
        task?.task_status = (TaskStatus.completed.rawValue) as NSNumber
        Config.db_context.mr_saveToPersistentStoreAndWait()
        onResult.onNext(.success(()))
    }

    func logout() {
        AppUser.user?.is_active = false
        Config.db_context.mr_saveToPersistentStoreAndWait()
        onLogout.onNext(())
    }
}

enum TodoTask {
    struct Request: RequestType {
        var taskTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
        var dateTime: BehaviorRelay<String> = BehaviorRelay(value: "")

        func toRequest() -> [String: Any] {
            let request: [String: Any] = ["task_title": taskTitle.value,
                                          "task_end_date": dateTime.value,
                                          "task_created_date": Date(),
                                          "task_id": UUID().uuidString,
                                          "task_status": TaskStatus.inprogress.rawValue]
            return request
        }
    }

    enum SortType: Int {
        case task_title
        case task_end_date

        var field: String {
            switch self {
            case .task_title:
                return "task_title"
            case .task_end_date:
                return "task_end_date"
            }
        }
    }
}
