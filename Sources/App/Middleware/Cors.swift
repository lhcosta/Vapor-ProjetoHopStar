//
//  File.swift
//  
//
//  Created by Lucas Costa  on 08/07/20.
//

import Foundation
import Vapor

final class Cors {
    
    /// Adicionando cors no servidor.
    /// - Parameter app: aplicação.
    static func add(in app: Application) {
        
        let corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .all, 
            allowedMethods: [.GET, .POST, .DELETE, .OPTIONS, .PATCH, .PUT], 
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin])
        
        let cors = CORSMiddleware(configuration: corsConfiguration)
        let error = ErrorMiddleware.default(environment: app.environment)
        
        app.middleware = .init()
        app.middleware.use(cors)
        app.middleware.use(error)
    } 
    
}
