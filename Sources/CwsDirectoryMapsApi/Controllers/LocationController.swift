import Fluent
import Vapor

struct LocationController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let locations = routes.grouped("locations")

        locations.get(use: self.index)
        locations.post(use: self.create)
        locations.group(":id") { location in
            location.get(use: self.show)
            location.put(use: self.update)
            location.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [LocationDTO] {
        try await Location.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func show(req: Request) async throws -> LocationDTO {
        guard let location = try await Location.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return location.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> LocationDTO {
        let location = try req.content.decode(LocationDTO.self).toModel()

        try await location.save(on: req.db)
        return location.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> LocationDTO {
        guard let location = try await Location.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updateData = try req.content.decode(LocationDTO.self)
        location.x = updateData.x
        location.y = updateData.y
        location.z = updateData.z ?? 0.0
        
        try await location.save(on: req.db)
        return location.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let location = try await Location.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await location.delete(on: req.db)
        return .noContent
    }
}