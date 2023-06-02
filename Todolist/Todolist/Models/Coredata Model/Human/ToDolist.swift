import Foundation

@objc(ToDolist)
open class ToDolist: _ToDolist {
    // Custom logic goes here.

    var status: TaskStatus {
        guard let status = task_status?.intValue, let task_status = TaskStatus(rawValue: status) else { return .inprogress }
        return task_status
    }
}
