//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Foundation
import Fluent

struct ResponsibleMigration: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Responsible")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required).unique(on: "email")
            .field("password", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("Responsible").delete()
    }
    
}
