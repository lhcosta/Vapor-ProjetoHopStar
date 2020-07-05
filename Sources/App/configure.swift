import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    if let url = Environment.get("DATABASE_URL"), let config = PostgresConfiguration(url: url) {
        app.databases.use(.postgres(configuration: config), as: .psql)
    }
    
    app.migrations.add(ResponsibleMigration())
    app.migrations.add(PatientMigration())
    app.migrations.add(TemperatureMigration())
    app.migrations.add(PressureMigration())

    // register routes
    try routes(app)
}
