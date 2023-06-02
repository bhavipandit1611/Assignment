//
//  AppUser.swift
//  Todolist
//
//  Created by Bhavi on 01/06/23.
//

import CoreData
import Foundation

var userDefaultBoolSetting = UserDefaultsRepository<Bool>(userDefaults: UserDefaults.standard)
var userDefaultAny = UserDefaultsRepository<Any>(userDefaults: UserDefaults.standard)
var userDefaultStringSetting = UserDefaultsRepository<String>(userDefaults: UserDefaults.standard)

enum AppUser {
    case inContext(NSManagedObjectContext)

    var user: Users? {
        switch self {
        case let .inContext(context):
            return Users.mr_findFirst(with: NSPredicate(format: "is_active = true"), in: context)
        }
    }

    static var user: Users? {
        return Users.mr_findFirst(with: NSPredicate(format: "is_active = true"), in: Config.db_context)
    }

    static var userId: String {
        guard let userId = user?.uuid else {
            return ""
        }
        return userId
    }
}
