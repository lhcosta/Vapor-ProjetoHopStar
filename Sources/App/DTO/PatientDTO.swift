//
//  File.swift
//  
//
//  Created by Lucas Costa  on 06/07/20.
//

import Foundation
import Vapor

final class PatientDTO: Content {    
    
    var id: UUID?
    var name: String
    var address: String
    var age: Int
    var genre: String
    var responsible: UUID?
    var defaultTemp: TemperatureDTO
    var defaultPressure: PressureDTO
    
    init(id: UUID?, name: String, address: String, age: Int, genre: String, responsible: UUID?, defaultTemp: TemperatureDTO, defaultPressure: PressureDTO) {
        self.id = id
        self.name = name
        self.address = address
        self.age = age
        self.genre = genre
        self.responsible = responsible
        self.defaultTemp = defaultTemp
        self.defaultPressure = defaultPressure
    }
    
}

extension PatientDTO: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("genre", as: String.self, is: !.empty, required: true)
        validations.add("age", as: Int.self, is: .range(1...100), required: true)
        validations.add("address", as: String.self, is: !.empty && .count(10...60), required: true)
        validations.add("defaultTemp", as: TemperatureDTO.self, required: true)
        validations.add("defaultPressure", as: PressureDTO.self, required: true)
    }    
}
