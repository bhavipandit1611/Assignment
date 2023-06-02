// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Users.swift instead.

import Foundation
import CoreData

public enum UsersAttributes: String {
    case email = "email"
    case is_active = "is_active"
    case name = "name"
    case password = "password"
    case uuid = "uuid"
}

public enum UsersRelationships: String {
    case todolist = "todolist"
}

public enum UsersUserInfo: String {		
    case relatedByAttribute = "relatedByAttribute"		
}

open class _Users: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Users"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Users.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var email: String?

    @NSManaged open
    var is_active: NSNumber?

    @NSManaged open
    var name: String?

    @NSManaged open
    var password: String?

    @NSManaged open
    var uuid: String?

    // MARK: - Relationships

    @NSManaged open
    var todolist: NSSet

    open func todolistSet() -> NSMutableSet {
        return self.todolist.mutableCopy() as! NSMutableSet
    }

}

extension _Users {

    open func addTodolist(_ objects: NSSet) {
        let mutable = self.todolist.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.todolist = mutable.copy() as! NSSet
    }

    open func removeTodolist(_ objects: NSSet) {
        let mutable = self.todolist.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.todolist = mutable.copy() as! NSSet
    }

    open func addTodolistObject(_ value: ToDolist) {
        let mutable = self.todolist.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.todolist = mutable.copy() as! NSSet
    }

    open func removeTodolistObject(_ value: ToDolist) {
        let mutable = self.todolist.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.todolist = mutable.copy() as! NSSet
    }

}

