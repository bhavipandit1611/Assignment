// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Task.swift instead.

import Foundation
import CoreData

public enum TaskAttributes: String {
    case task_created_date = "task_created_date"
    case task_end_date = "task_end_date"
    case task_id = "task_id"
    case task_status = "task_status"
    case task_title = "task_title"
}

open class _Task: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Task"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Task.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var task_created_date: Date?

    @NSManaged open
    var task_end_date: Date?

    @NSManaged open
    var task_id: String?

    @NSManaged open
    var task_status: NSNumber?

    @NSManaged open
    var task_title: String?

    // MARK: - Relationships

}

