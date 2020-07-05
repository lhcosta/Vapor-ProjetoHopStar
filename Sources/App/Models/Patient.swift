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
    
    @Children(for: \.$patient)
    var pressures: [Pressure]
    
    @Children(for: \.$patient)
    var temperatures: [Temperature]

    init() {}
    
    init(name: String, genre: String, age: Int, address: String, respId: UUID) {
        self.name = name
        self.genre = genre
        self.age = age
        self.address = address
        self.$responsible.id = respId
    }
}

extension Patient: Validatable {
    
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("genre", as: String.self, is: !.empty, required: true)
        validations.add("age", as: Int.self, is: .range(1...100), required: true)
        validations.add("address", as: String.self, is: !.empty && .count(10...60), required: true)
    }    
}

