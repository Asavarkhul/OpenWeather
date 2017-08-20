//
//  TestRealm.swift
//  OpenWeather
//
//  Created by Bertrand on 18/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    static func useCleanMemoryRealmByDefault(identifier: String = "memory") {
        var config = Realm.Configuration.defaultConfiguration
        config.inMemoryIdentifier = identifier
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        try! realm.write(realm.deleteAll)
    }
}
