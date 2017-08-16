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
            formatter.timeZone = TimeZone(identifier: "GMT")
            formatter.dateStyle = .full
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()
    }
    return Static.instance
}

public var literalDayFormat: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "GMT")
            formatter.dateFormat = "EEE"
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()
    }
    return Static.instance
}

public var literalDayFullFormat: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "GMT")
            formatter.dateFormat = "EEEE"
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()
    }
    return Static.instance
}

public var dayFormat: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "GMT")
            formatter.dateFormat = "dd"
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()
    }
    return Static.instance
}
