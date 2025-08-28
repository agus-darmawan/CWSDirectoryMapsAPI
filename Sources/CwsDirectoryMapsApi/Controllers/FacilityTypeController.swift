import Fluent
import Vapor

struct FacilityTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let facilityTypes = routes.grouped("facility-types")

        facilityTypes.get(use: self.index)
        facilityTypes.post(use: self.create)
        facilityTypes.group(":id") { facilityType in
            facilityType.get(use: self.show)
            facilityType.put(use: self.update)
            facilityType.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [FacilityTypeDTO] {
        try await FacilityType.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func show(req: Request) async throws -> FacilityTypeDTO {
        guard let facilityType = try await FacilityType.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return facilityType.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> FacilityTypeDTO {
        let facilityType = try req.content.decode(FacilityTypeDTO.self).toModel()

        try await facilityType.save(on: req.db)
        return facilityType.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> FacilityTypeDTO {
        guard let facilityType = try await FacilityType.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updateData = try req.content.decode(FacilityTypeDTO.self)
        facilityType.name = updateData.name
        
        try await facilityType.save(on: req.db)
        return facilityType.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let facilityType = try await FacilityType.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await facilityType.delete(on: req.db)
        return .noContent
    }
}