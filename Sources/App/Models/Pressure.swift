//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Foundation
import Fluent
import Vapor

final class Pressure: Model, Content {
        
    static let schema = "Pressure"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "diastolic")
    var diastolic: Float
    
    @Field(key: "systolic")
    var systolic: Float
    
    @Timestamp(key: "created_at", on: .create)
    var date: Date?
    
    @Parent(key: "patient_id")
    var patient: Patient
    
    @Field(key: "is_default")
    var isDefault: Bool?
    
    init() {}
    
    init(diastolic: Float, systolic: Float, isDefault: Bool? = false, paciente: UUID) {
        self.diastolic = diastolic
        self.systolic = systolic
        self.isDefault = isDefault
        self.$patient.id = paciente
    }
    
}

extension Pressure {
    func mapper() -> PressureDTO {
        return PressureDTO(diastolic: self.diastolic, systolic: self.systolic)
    }
}
