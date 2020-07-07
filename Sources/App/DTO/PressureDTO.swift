//
//  File.swift
//  
//
//  Created by Lucas Costa  on 06/07/20.
//

import Foundation
import Vapor

final class PressureDTO: Content {
    
    var diastolic: Float
    var systolic: Float
    
    init(diastolic: Float, systolic: Float) {
        self.diastolic = diastolic
        self.systolic = systolic
    }
}

extension PressureDTO: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("diastolic", as: Float.self, required: true)
        validations.add("systolic", as: Float.self, required: true)
    }
}
