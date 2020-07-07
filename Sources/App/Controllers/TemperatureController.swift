//
//  File.swift
//  
//
//  Created by Lucas Costa  on 04/07/20.
//

import Foundation
import Vapor
import Fluent

class TemperatureController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let temp = routes.grouped("temperature")
        temp.post(use: create(_:))
    }
    
    /// Criando uma nova temperatura do paciente. 
    /// - Parameter req: POST Request
    /// - Returns: temperatura criada.
    func create(_ req: Request) throws -> EventLoopFuture<TemperatureDTO> {
        let temperature = try req.content.decode(Temperature.self) 
        return Temperature.create(temperature)(on: req.db).map({ temperature.mapper() })
    }
    
}
