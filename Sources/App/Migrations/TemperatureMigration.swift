//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Foundation
import Fluent

struct TemperatureMigration: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Temperature")
            .field(.id, .int, .identifier(auto: true))
            .field("value", .float)
            .field("patient_id", .uuid, .references("Patient", .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Temperature").delete()
    }
    
}
