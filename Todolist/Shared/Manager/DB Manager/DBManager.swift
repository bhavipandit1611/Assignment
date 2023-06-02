import CoreData
import Foundation
import MagicalRecord

class DBManager {
    static var shared: DBMangerLogic = DBManager()
}

extension DBManager: DBMangerLogic {
    func storeUser(data: [String: Any], completion: @escaping ((Bool) -> Void)) {
        MagicalRecord.save { local in
            Users.mr_import(from: data, in: local)
        } completion: { _, _ in
            completion(true)
        }
    }

    func checkUserExist(email: String, password: String) -> Bool {
        if let objUser = Users.mr_findFirst(with: NSPredicate(format: "email = %@ && password = %@", email, password), in: Config.db_context) {
            return true
        }
        return false
    }

    func AddTask(data: [String: Any], completion: @escaping ((Bool) -> Void)) {
        MagicalRecord.save { local in
            let objUser = Users.mr_findFirst(with: NSPredicate(format: "uuid = %@", AppUser.userId), in: local)
            let objTodo = ToDolist.mr_import(from: data, in: local)
            objUser?.addTodolist(NSSet(array: [objTodo as Any]))
        } completion: { _, _ in
            completion(true)
        }
    }
}
