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
    
    Cors.add(in: app)

    //Migrations
    app.migrations.add(ResponsibleMigration())
    app.migrations.add(PatientMigration())
    app.migrations.add(TemperatureMigration())
    app.migrations.add(PressureMigration())
    
    // register routes
    try routes(app)
}
