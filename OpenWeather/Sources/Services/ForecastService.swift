//
//  ForecastService.swift
//  OpenWeather
//
//  Created by Bertrand on 14/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct ForecastService {
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
    func forecasts() -> Observable<Results<Forecast>> {
        let result = withRealm("Getting conditions") { realm -> Observable<Results<Forecast>> in
            let realm = try Realm()
            let forecasts = realm.objects(Forecast.self)
            return Observable.collection(from: forecasts)
        }
        return result ?? .empty()
    }
}
