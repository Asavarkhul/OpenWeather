//
//  IconURLTransformer.swift
//  OpenWeather
//
//  Created by Bertrand on 14/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import ObjectMapper

struct IconURLTransformer:TransformType {
    typealias Object = String
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let iconName = value {
            return "http://openweathermap.org/img/w/\(iconName).png"
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}
