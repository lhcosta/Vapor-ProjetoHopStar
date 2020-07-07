import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    if let url = Environment.get("DATABASE_URL"), let config = PostgresConfiguration(url: url) {
        app.databases.use(.postgres(configuration: config), as: .psql)
    } else {
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            username: Environment.get("DATABASE_USERNAME") ?? "root",
            password: Environment.get("DATABASE_PASSWORD") ?? "",
            database: Environment.get("DATABASE_NAME") ?? "ProjetoHopStar"
            ), as: .psql)
    }
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all, 
        allowedMethods: [.GET, .POST, .DELETE, .OPTIONS, .PATCH, .PUT], 
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin])
    
    let cors = CORSMiddleware(configuration: corsConfiguration)
    let error = ErrorMiddleware.default(environment: app.environment)
    
    app.middleware = .init()
    app.middleware.use(cors)
    app.middleware.use(error)
    
    app.migrations.add(ResponsibleMigration())
    app.migrations.add(PatientMigration())
    app.migrations.add(TemperatureMigration())
    app.migrations.add(PressureMigration())
    
    // register routes
    try routes(app)
}
