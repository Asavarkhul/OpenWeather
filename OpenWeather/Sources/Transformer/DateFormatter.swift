//
//  DateFormatter.swift
//  OpenWeather
//
//  Created by Bertrand on 15/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation

public struct Day {
    public static func tomorrowMinusCurrentHour() -> Date? {
        let today = Date()
        let currentHour = Int(hourFormat.string(from: today))
        let tomorrowAtSameHour = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let tomorrowMinusCurrentHour = Calendar.current.date(byAdding: .hour, value: -currentHour!, to: tomorrowAtSameHour!)
        return tomorrowMinusCurrentHour
    }
}

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

public var hourFormat: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "GMT")
            formatter.dateFormat = "H"
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()
    }
    return Static.instance
}

public var literalHourFormat: DateFormatter {
    struct Static {
        static let instance : DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "GMT")
            formatter.dateFormat = "hh a"
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()
    }
    return Static.instance
}
