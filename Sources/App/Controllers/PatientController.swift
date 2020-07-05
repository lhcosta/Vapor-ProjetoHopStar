//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Vapor
import Fluent

class PatientController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {        
        let paciente = routes.grouped("patient")
        paciente.post(use: create(_:))
        paciente.get(":id", "pressure", use: selectPressure(_:))
        paciente.get(":id", "temperature", use: selectTemperature(_:))
    }
    
    /// Criando um paciente
    /// - Parameter req: POST Request.
    /// - Throws: erro ao criar um novo paciente.
    /// - Returns: paciente criado.
    func create(_ req: Request) throws -> EventLoopFuture<Patient> {
        try Patient.validate(req)
        let paciente = try req.content.decode(Patient.self)
        return Patient.create(paciente)(on: req.db).map { paciente }    
    }
    
    /// Selecionando todas as pressões do usuário.
    /// - Parameter req: GET Request
    /// - Throws: paciente não encontrado.
    /// - Returns: todas as pressões do paciente.
    func selectPressure(_ req: Request) throws -> EventLoopFuture<[Pressure]> {
        guard let id_string = req.parameters.get("id"), let id = UUID(uuidString: id_string) else { throw Abort(.noContent)}
        
        return Patient.find(id, on: req.db).flatMapThrowing { (patient) -> [Pressure] in
            guard let patient = patient else { throw Abort(.notFound) }
            return patient.pressures
        }
        .map({$0})
    }
    
    /// Selecionando todas as temperaturas do usuário.
    /// - Parameter req: GET Request
    /// - Throws: paciente não encontrado.
    /// - Returns: todas as temperaturas do paciente.
    func selectTemperature(_ req: Request) throws -> EventLoopFuture<[Temperature]> {
        guard let id_string = req.parameters.get("id"), let id = UUID(uuidString: id_string) else { throw Abort(.noContent)}
        
        return Patient.find(id, on: req.db).flatMapThrowing { (patient) -> [Temperature] in
            guard let patient = patient else { throw Abort(.notFound) }
            return patient.temperatures
        }
        .map({$0})
    }
    
}
