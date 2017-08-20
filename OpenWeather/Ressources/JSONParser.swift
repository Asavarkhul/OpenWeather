//
//  JSONParser.swift
//  OpenWeather
//
//  Created by Bertrand on 20/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation

public final class JSONParser {
    static func readJSONFile(forName name: String) -> [String: Any] {
        do {
            if let file = Bundle.main.url(forResource: name, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonObject = json as? [String: Any] {
                    return jsonObject
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return [:]
    }
}
