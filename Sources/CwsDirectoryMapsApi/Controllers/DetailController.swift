import Fluent
import Vapor

struct DetailController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let details = routes.grouped("details")

        details.get(use: self.index)
        details.post(use: self.create)
        details.group(":id") { detail in
            detail.get(use: self.show)
            detail.put(use: self.update)
            detail.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [DetailDTO] {
        try await Detail.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func show(req: Request) async throws -> DetailDTO {
        guard let detail = try await Detail.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return detail.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> DetailDTO {
        let detail = try req.content.decode(DetailDTO.self).toModel()

        try await detail.save(on: req.db)
        return detail.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> DetailDTO {
        guard let detail = try await Detail.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updateData = try req.content.decode(DetailDTO.self)
        detail.description = updateData.description
        detail.phone = updateData.phone
        detail.website = updateData.website
        detail.unit = updateData.unit
        detail.openTime = updateData.openTime
        detail.closeTime = updateData.closeTime
        
        try await detail.save(on: req.db)
        return detail.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let detail = try await Detail.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await detail.delete(on: req.db)
        return .noContent
    }
}