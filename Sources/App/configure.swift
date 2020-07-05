import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(url: "DATABASE_URL"), as: .psql)
    
    app.migrations.add(ResponsibleMigration())
    app.migrations.add(PatientMigration())
    app.migrations.add(TemperatureMigration())
    app.migrations.add(PressureMigration())

    // register routes
    try routes(app)
}
