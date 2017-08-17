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
            return iconNameToChar(icon: iconName as! String)
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}

/**
 * Maps an icon information from the API to a local char
 * Source: http://openweathermap.org/weather-conditions
 */
func iconNameToChar(icon: String) -> String {
    switch icon {
    case "01d":
        return "\u{f11b}"
    case "01n":
        return "\u{f110}"
    case "02d":
        return "\u{f112}"
    case "02n":
        return "\u{f104}"
    case "03d", "03n":
        return "\u{f111}"
    case "04d", "04n":
        return "\u{f111}"
    case "09d", "09n":
        return "\u{f116}"
    case "10d", "10n":
        return "\u{f113}"
    case "11d", "11n":
        return "\u{f10d}"
    case "13d", "13n":
        return "\u{f119}"
    case "50d", "50n":
        return "\u{f10e}"
    default:
        return "E"
    }
}
