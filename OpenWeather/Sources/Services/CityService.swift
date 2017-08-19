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

struct CityService {
    // MARK: - Properties
    fileprivate let city: City!
    fileprivate let conditionService: ConditionService!
    fileprivate let forecastService: ForecastService!
    
    init(for city: City) {
        self.city = city
        self.conditionService = ConditionService()
        self.forecastService = ForecastService()
    }
    
    //MARK: Update
    func update(_ completion:@escaping (_ error: Error?) -> ()){
        self.updateCurrentCondition { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            self.updateForecast(completion)
        }
    }
    
    //MARK: Current condition
    func updateCurrentCondition(_ completion:@escaping (_ error: Error?) -> Void){
        conditionService.loadCurrentCondition(for: self.city, success: { condition in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(condition, update: true)
                    self.city.currentCondition = condition
                    completion(nil)
                }
            } catch {
                completion(RealmError.unableToSave)
            }
        }) { error in
            completion(error)
        }
    }
    
    //MARK: Forecast
    func updateForecast(_ completion:@escaping (_ error: Error?) -> Void){
        forecastService.loadForecast(for: self.city, success: { forecasts in
            do {
                let realm = try Realm()
                try realm.write {
                    for forecast in forecasts {
                        if let date = forecast.date {
                            forecast.hour = hourFormat.string(from: date)
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
                completion(RealmError.unableToSave)
            }
        }) { error in
            completion(error)
        }
    }
}

extension CityService {
    enum RealmError: Error {
        case unableToSave
    }
}
