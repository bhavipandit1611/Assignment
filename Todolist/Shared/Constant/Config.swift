// import AFDateHelper
import CoreData
import Foundation
import RxCocoa
import RxSwift
import UIKit

class Config {
    static var app_name = "Todolist"
    static var db = "Todolist"
    static var db_context: NSManagedObjectContext!
    static var db_memory_context: NSManagedObjectContext!
    static var delegate = UIApplication.shared.delegate as! AppDelegate
}

