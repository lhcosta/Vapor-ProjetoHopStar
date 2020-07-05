//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Foundation
import Fluent

struct PressureMigration: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Pressure")
            .field(.id, .int, .identifier(auto: true))
            .field("diastolic", .float)
            .field("systolic", .float)
            .field("patient_id", .uuid, .references("Patient", .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Pressure").delete()
    }
    
}
