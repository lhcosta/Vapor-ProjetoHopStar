//
//  File.swift
//  
//
//  Created by Lucas Costa  on 04/07/20.
//

import Fluent
import Vapor

class PressureController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let pressure = routes.grouped("pressure")
        pressure.post(use: create(_:))
    }
    
    /// Criando uma nova pressão do usuário. 
    /// - Parameter req: POST Request
    /// - Returns: pressão criada.
    func create(_ req: Request) throws -> EventLoopFuture<Pressure> {
        let pressure = try req.content.decode(Pressure.self) 
        return Pressure.create(pressure)(on: req.db).map({pressure})
    }
}
