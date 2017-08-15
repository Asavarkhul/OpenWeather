//
//  DateFormatter.swift
//  OpenWeather
//
//  Created by Bertrand on 15/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation

public var fullDateFormat: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            return formatter
        }()
    }
    return Static.instance
}

public var dayFormat: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            formatter.timeZone = TimeZone(identifier: "GMT")
            return formatter
        }()
    }
    return Static.instance
}
