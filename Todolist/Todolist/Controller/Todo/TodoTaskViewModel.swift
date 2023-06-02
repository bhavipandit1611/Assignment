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
    func AddTask()
    func UpdateTask(task: ToDolist)
}

protocol TodoTaskViewModelOuptput: ActivityIndicatorProtocol {
    var onResult: PublishSubject<Result<Void, ErrorHandler>> { get set }
    var request: TodoTask.Request { get set }
}

protocol TodoTaskViewModelOuptputType {
    var input: TodoTaskViewModelInputs { get set }
    var output: TodoTaskViewModelOuptput { get set }
}

class TodoTaskViewModel: TodoTaskViewModelInputs, TodoTaskViewModelOuptput, TodoTaskViewModelOuptputType {
    var is_animating: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var input: TodoTaskViewModelInputs { get { return self } set {} }
    var output: TodoTaskViewModelOuptput { get { return self } set {} }

    var onResult: PublishSubject<Result<Void, ErrorHandler>> = PublishSubject()
    var request = TodoTask.Request()

    var bag = DisposeBag()

    func AddTask() {
        is_animating.accept(true)

        DBManager.shared.AddTask(data: request.toRequest()) { [weak self] _ in
            self?.onResult.onNext(.success(()))
        }
    }

    func UpdateTask(task: ToDolist) {
    }
}

enum TodoTask {
    struct Request: RequestType {
        var taskTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
        var dateTime: BehaviorRelay<String> = BehaviorRelay(value: "")
        var date_Time: BehaviorRelay<String> = BehaviorRelay(value: "")

        func toRequest() -> [String: Any] {
            let request: [String: Any] = ["task_title": taskTitle.value,
                                          "task_end_date": date_Time.value,
                                          "task_created_date": Date(),
                                          "task_id": UUID().uuidString,
                                          "task_status": TaskStatus.inprogress.rawValue]
            return request
        }
    }
}
