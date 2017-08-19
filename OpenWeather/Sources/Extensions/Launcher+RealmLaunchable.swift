//
//  Launcher+RealmLaunchable.swift
//  OpenWeather
//
//  Created by Bertrand on 19/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmLaunchable {
    static func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T?
}

public struct Launcher: RealmLaunchable {
    public static func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
}
