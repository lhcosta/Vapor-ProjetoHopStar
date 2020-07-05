//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Foundation
import Fluent

struct PatientMigration: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Patient")
            .id()
            .field("name", .string)
            .field("genre", .string)
            .field("age", .int)
            .field("address", .string)
            .field("resp_id", .uuid, .references("Responsible", .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Patient").delete()
    }
    
    
}
