//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Foundation
import Fluent
import Vapor

final class Temperature: Model, Content {
    
    static let schema = "Temperature"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "value")
    var value: Float
    
    @Field(key: "is_default")
    var isDefault: Bool?
    
    @Timestamp(key: "created_at", on: .create)
    var date: Date?
    
    @Parent(key: "patient_id")
    var patient: Patient
    
    init() {}
    
    init(value: Float, isDefault: Bool? = false, paciente: UUID) {
        self.value = value
        self.$patient.id = paciente
        self.isDefault = isDefault
    }
}

extension Temperature {
    func mapper() -> TemperatureDTO {
        return TemperatureDTO(value: self.value)
    }
}
