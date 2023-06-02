
import Foundation
import MagicalRecord
protocol DBMangerLogic {
    func storeUser(data: [String: Any], completion: @escaping ((Bool) -> Void))
    func checkUserExist(email: String, password: String) -> Bool
    func AddTask(data: [String: Any], completion: @escaping ((Bool) -> Void))
}
