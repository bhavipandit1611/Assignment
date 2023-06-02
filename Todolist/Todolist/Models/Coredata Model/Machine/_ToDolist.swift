// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ToDolist.swift instead.

import Foundation
import CoreData

public enum ToDolistRelationships: String {
    case user = "user"
}

public enum ToDolistUserInfo: String {		
    case relatedByAttribute = "relatedByAttribute"		
}

open class _ToDolist: Task {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "ToDolist"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _ToDolist.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    // MARK: - Relationships

    @NSManaged open
    var user: Users?

}

