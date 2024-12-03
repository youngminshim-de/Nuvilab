//
//  Data+Extension.swift
//  Nuvilab
//
//  Created by 심영민 on 12/4/24.
//

import Foundation

extension Data {
    var prettyJSON: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.withoutEscapingSlashes, .sortedKeys, .prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8)
        else { return nil }
        
        return prettyPrintedString
    }
}
