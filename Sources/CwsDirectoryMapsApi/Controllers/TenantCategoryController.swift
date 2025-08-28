import Fluent
import Vapor

struct TenantCategoryController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let tenantCategories = routes.grouped("tenant-categories")

        tenantCategories.get(use: self.index)
        tenantCategories.post(use: self.create)
        tenantCategories.group(":id") { tenantCategory in
            tenantCategory.get(use: self.show)
            tenantCategory.put(use: self.update)
            tenantCategory.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [TenantCategoryDTO] {
        try await TenantCategory.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func show(req: Request) async throws -> TenantCategoryDTO {
        guard let tenantCategory = try await TenantCategory.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return tenantCategory.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> TenantCategoryDTO {
        let tenantCategory = try req.content.decode(TenantCategoryDTO.self).toModel()

        try await tenantCategory.save(on: req.db)
        return tenantCategory.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> TenantCategoryDTO {
        guard let tenantCategory = try await TenantCategory.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updateData = try req.content.decode(TenantCategoryDTO.self)
        tenantCategory.name = updateData.name
        
        try await tenantCategory.save(on: req.db)
        return tenantCategory.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let tenantCategory = try await TenantCategory.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await tenantCategory.delete(on: req.db)
        return .noContent
    }
}