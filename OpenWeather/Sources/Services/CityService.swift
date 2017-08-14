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
    init() {}
    
    //MARK: Update
    func update(_ completion:@escaping (_ error:NSError?) -> ()){
        self.updateCurrentCondition { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            self.updateWeatherForecast(completion)
        }
    }
    
    //MARK: Current condition
    func updateCurrentCondition(_ completion:@escaping (_ error:NSError?) -> ()){
        
    }
    
    //MARK: Forecast
    func updateWeatherForecast(_ completion:@escaping (_ error:NSError?) -> ()){
        
    }
}
