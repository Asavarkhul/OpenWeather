//
//  ConditionsService.swift
//  OpenWeather
//
//  Created by Bertrand on 14/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct ConditionService {
    init() {}
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    @discardableResult
    func conditions() -> Observable<Results<Condition>> {
        let result = withRealm("Getting conditions") { realm -> Observable<Results<Condition>> in
            let conditions = realm.objects(Condition.self)
            return Observable.collection(from: conditions)
        }
        return result ?? .empty()
    }
}
