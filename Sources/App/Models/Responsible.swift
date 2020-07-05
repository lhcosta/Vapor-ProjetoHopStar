//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Foundation
import Vapor
import Fluent
import CBcrypt

final class Responsible: Model, Content {
    
    static let schema = "Responsible"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$responsible)
    var patients: [Patient]
    
    init() {}
    
    init(nome: String, email: String, password: String) {
        self.name = nome
        self.email = email
        self.password = password
    }
}

extension Responsible: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("email", as: String.self, is: .email, required: true)
        validations.add("password", as: String.self, is: .count(8...), required: true)
    }
}

extension Responsible: ModelAuthenticatable {
    
    static var usernameKey: KeyPath<Responsible, Field<String>> {
        return \Responsible.$email
    }
    
    static var passwordHashKey: KeyPath<Responsible, Field<String>> {
        return \Responsible.$password
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
    
}
