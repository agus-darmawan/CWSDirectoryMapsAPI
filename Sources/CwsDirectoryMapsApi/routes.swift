import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "CWS Directory Maps API - It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    // API versioning group
    let v1 = app.grouped("api", "v1")
    try v1.register(collection: FacilityTypeController())
    try v1.register(collection: TenantCategoryController())
    try v1.register(collection: LocationController())
    try v1.register(collection: DetailController())
    try v1.register(collection: FacilityController())
}