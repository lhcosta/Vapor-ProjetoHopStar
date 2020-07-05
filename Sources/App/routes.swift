import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let patientController = PatientController()
    let respController = ResponsibleController()
    let temperatureController = TemperatureController()
    let pressureController = PressureController()
    let api = app.grouped("api")
    
    try api.register(collection: respController)
    try api.register(collection: patientController)
    try api.register(collection: temperatureController)
    try api.register(collection: pressureController)
    
}
