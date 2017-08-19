//
//  City.swift
//  OpenWeather
//
//  Created by Bertrand on 10/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object {
    // MARK: - Properties
    dynamic var identifier:Int = 0
    dynamic var name = ""
    dynamic var currentCondition: Condition?
    let forecasts = List<Forecast>()
}

//MARK: - Static
extension City {
    static func getCurrentCityIfExistsOrCreatesOne() -> City {
        do {
            let realm = try Realm()
            if let currentCity = realm.objects(City.self).first {
                return currentCity
            }
            
            let newCity = City()
            newCity.identifier = 2988507
            newCity.name = "Paris"
            try realm.write {
                realm.add(newCity)
            }
            return newCity
        } catch {
            fatalError("Can not itialize Realm store")
        }
    }
}
