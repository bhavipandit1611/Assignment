import Foundation

@objc(ToDolist)
open class ToDolist: _ToDolist {
    // Custom logic goes here.

    var status: TaskStatus {
        guard let status = task_status?.intValue, let task_status = TaskStatus(rawValue: status) else { return .inprogress }
        return task_status
    }

    var isExceed: Bool {
        if let task_end_date = task_end_date, let strDate = Date().toString(format: DateFormat.month_date_time_ampm_format), let currentDate = Date(detectFromString: strDate) {
            if task_end_date < currentDate {
                return true
            }
        }
        return false
    }
}
