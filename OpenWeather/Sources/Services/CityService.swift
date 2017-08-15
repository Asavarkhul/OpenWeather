//
//  CityService.swift
//  OpenWeather
//
//  Created by Bertrand on 14/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct CityService {
    fileprivate let city: City!
    
    init(for city: City) {
        self.city = city
    }
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    //MARK: Update
    func update(_ completion:@escaping (_ error:NSError?) -> ()){
        self.updateCurrentCondition { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            self.updateForecast(completion)
        }
    }
    
    func update() -> Observable<Void> {
        return Observable.create { observer in
            self.updateCurrentCondition { error in
                guard error == nil else {
                    return observer.onError(error!)
                }
                self.updateForecast() { error in
                    guard error == nil else {
                        return observer.onError(error!)
                    }
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    //MARK: Current condition
    func updateCurrentCondition(_ completion:@escaping (_ error: NSError?) -> Void){
        Condition.loadCurrentCondition(for: self.city) { condition in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(condition, update: true)
                    self.city.currentCondition = condition
                    completion(nil)
                }
            } catch {
                completion(NSError())
            }
        }
    }
    
    //MARK: Forecast
    func updateForecast(_ completion:@escaping (_ error: NSError?) -> Void){
        Forecast.loadForecast(for: self.city) { forecasts in
            do {
                let realm = try Realm()
                try realm.write {
                    for forecast in forecasts {
                        if let date = forecast.date {
                            forecast.day = dayFormat.string(from: date)
                        }
                        forecast.uid = forecast.date?.description ?? Date().timeIntervalSinceReferenceDate.description
                    }
                    realm.add(forecasts, update: true)
                    self.city.forecasts.removeAll()
                    self.city.forecasts.append(objectsIn: forecasts)
                    completion(nil)
                }
            } catch {
                completion(NSError())
            }
        }
    }
}
