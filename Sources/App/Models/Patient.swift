//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Foundation
import Fluent
import Vapor

final class Patient : Model, Content {

    static let schema = "Patient"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "genre")
    var genre: String
    
    @Field(key: "age")
    var age: Int
    
    @Field(key: "address")
    var address: String
    
    @OptionalParent(key: "resp_id")
    var responsible: Responsible?
    
    //ONE-TO-ONE
    @Children(for: \.$patient)
    var defaultPressure: [Pressure]
    
    //ONE-TO-ONE
    @Children(for: \.$patient)
    var defaultTemperature: [Temperature]
    
    @Children(for: \.$patient)
    var pressures: [Pressure]
    
    @Children(for: \.$patient)
    var temperatures: [Temperature]

    init() {}
    
    init(name: String, genre: String, age: Int, address: String, respId: UUID?) {
        self.name = name
        self.genre = genre
        self.age = age
        self.address = address
        self.$responsible.id = respId

    }
}

extension Patient {
    
    func mapper(defaultTemp: TemperatureDTO, defaultPressure: PressureDTO) -> PatientDTO {
        return PatientDTO(id: self.id, 
                          name: self.name, 
                          address: self.address,
                          age: self.age,
                          genre: self.genre, 
                          responsible: self.responsible?.id, 
                          defaultTemp: defaultTemp, 
                          defaultPressure: defaultPressure)
    }
}

