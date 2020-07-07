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
        paciente.delete(":id", use: delete(_:))
    }
    
    /// Criando um paciente
    /// - Parameter req: POST Request.
    /// - Throws: erro ao criar um novo paciente.
    /// - Returns: paciente criado.
    func create(_ req: Request) throws -> EventLoopFuture<PatientDTO> {
        
        try PatientDTO.validate(req)
        let patientDTO = try req.content.decode(PatientDTO.self)
        
        let patient = Patient(name: patientDTO.name, 
                              genre: patientDTO.genre, 
                              age: patientDTO.age, 
                              address: patientDTO.address, 
                              respId: patientDTO.responsible)
        
        return Patient.save(patient)(on: req.db).map({ 
            
            let pressure = Pressure(diastolic: patientDTO.defaultPressure.diastolic, systolic: patientDTO.defaultPressure.systolic, isDefault: true, paciente: patient.id!)
            let temp = Temperature(value: patientDTO.defaultTemp.value, isDefault: true, paciente: patient.id!)
            
            _ = Pressure.save(pressure)(on: req.db)
            _ = Temperature.save(temp)(on: req.db)
            
            return patient.mapper(defaultTemp: temp.mapper(), defaultPressure: pressure.mapper())
        })
    }
    
    /// Selecionando todas as pressões do usuário.
    /// - Parameter req: GET Request
    /// - Throws: paciente não encontrado.
    /// - Returns: todas as pressões do paciente.
    func selectPressure(_ req: Request) throws -> EventLoopFuture<[PressureDTO]> {
        let patient = try selectPatient(req)
        return patient.flatMap {
            $0.$pressures.query(on: req.db)
                .filter(\.$isDefault == false)
                .sort(\.$date)
                .all()
        }
        .mapEach({ $0.mapper() })
    }
    
    /// Selecionando todas as temperaturas do usuário.
    /// - Parameter req: GET Request
    /// - Throws: paciente não encontrado.
    /// - Returns: todas as temperaturas do paciente.
    func selectTemperature(_ req: Request) throws -> EventLoopFuture<[TemperatureDTO]> {
        let patient = try selectPatient(req)
        return patient.flatMap {
            $0.$temperatures.query(on: req.db)
                .filter(\.$isDefault == false)
                .sort(\.$date)
                .all()
        }
        .mapEach({ $0.mapper() })
    }
    
    
    /// Deletar um paciente.
    /// - Parameter req: DELETE Request
    /// - Throws: paciente não encontrado.
    /// - Returns: status da ação.
    func delete(_ req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        return try selectPatient(req)
        .map { $0.delete(on: req.db) }
        .transform(to: HTTPStatus.ok)
    }
    
    func selectPatient(_ req: Request) throws -> EventLoopFuture<Patient> {
        guard let id_string = req.parameters.get("id"), let id = UUID(uuidString: id_string) else { throw Abort(.noContent)}
        return Patient.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
}
