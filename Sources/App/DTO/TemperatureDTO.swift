//
//  File.swift
//  
//
//  Created by Lucas Costa  on 06/07/20.
//

import Vapor

final class TemperatureDTO: Content {
    
    var value: Float
    
    init(value: Float) {
        self.value = value
    }
}

extension TemperatureDTO: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("value", as: Float.self, required: true)
    }
}
