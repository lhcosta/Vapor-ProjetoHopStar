//
//  File.swift
//  
//
//  Created by Lucas Costa  on 03/07/20.
//

import Fluent
import Vapor
import CBcrypt

class ResponsibleController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let resp = routes.grouped("resp")
        let auth = routes.grouped(Responsible.authenticator())
        
        resp.post(use: create(_:))
        resp.get(":id", "patient", use: selectAllPatients(_:))
        auth.post("login", use: login(_:))
    }
    
    /// Criando um novo usuário.
    /// - Parameter req: POST Request.
    /// - Throws: erro ao cadastrar um novo responsável.
    /// - Returns: responsável cadastrado.
    func create(_ req: Request) throws -> EventLoopFuture<Responsible> {
        try Responsible.validate(req)
        let resp = try req.content.decode(Responsible.self)
        let newResp = try Responsible(nome: resp.name, email: resp.email, password: Bcrypt.hash(resp.password))
        return newResp.save(on: req.db).map({ newResp })
    }
    
    /// Realizando login do usuário.
    /// - Parameter req: POST Request
    /// - Throws: usuário não autorizado
    /// - Returns: acesso autorizado. 
    func login(_ req: Request) throws -> Responsible {
        return try req.auth.require(Responsible.self)
    }
    
    /// Selecionando todos os pacientes de um responsável.
    /// - Parameter req: GET Request
    /// - Throws: responsável não existente.
    /// - Returns: todos os pacientes de um responsável.
    func selectAllPatients(_ req: Request) throws -> EventLoopFuture<[Patient]> {
        guard let resp_id = req.parameters.get("resp_id"), let id = UUID(resp_id) else { throw Abort(.noContent) }
        return Responsible.find(id, on: req.db)
            .flatMapThrowing { (resp) -> [Patient] in
                guard let resp = resp else { throw Abort(.notFound) }
                return resp.patients
        }
        .map({$0})
    }
    
}
