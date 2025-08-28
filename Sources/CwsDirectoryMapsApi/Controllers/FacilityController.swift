import Fluent
import Vapor

struct FacilityController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let facilities = routes.grouped("facilities")

        facilities.get(use: self.index)
        facilities.post(use: self.create)
        facilities.get("with-details", use: self.indexWithDetails)
        
        facilities.group(":id") { facility in
            facility.get(use: self.show)
            facility.put(use: self.update)
            facility.delete(use: self.delete)
            facility.get("with-details", use: self.showWithDetails)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [FacilityDTO] {
        try await Facility.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func indexWithDetails(req: Request) async throws -> [FacilityWithDetailsDTO] {
        let facilities = try await Facility.query(on: req.db)
            .with(\.$facilityType)
            .with(\.$tenantCategory)
            .with(\.$location)
            .with(\.$detail)
            .all()
        
        return facilities.map { facility in
            FacilityWithDetailsDTO(
                id: facility.id,
                name: facility.name,
                imagePath: facility.imagePath,
                facilityType: facility.facilityType.toDTO(),
                tenantCategory: facility.tenantCategory?.toDTO(),
                location: facility.location.toDTO(),
                detail: facility.detail?.toDTO()
            )
        }
    }

    @Sendable
    func show(req: Request) async throws -> FacilityDTO {
        guard let facility = try await Facility.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return facility.toDTO()
    }

    @Sendable
    func showWithDetails(req: Request) async throws -> FacilityWithDetailsDTO {
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing facility ID")
        }
        
        guard let facility = try await Facility.query(on: req.db)
            .filter(\.$id == id)
            .with(\.$facilityType)
            .with(\.$tenantCategory)
            .with(\.$location)
            .with(\.$detail)
            .first() else {
            throw Abort(.notFound)
        }
        
        return FacilityWithDetailsDTO(
            id: facility.id,
            name: facility.name,
            imagePath: facility.imagePath,
            facilityType: facility.facilityType.toDTO(),
            tenantCategory: facility.tenantCategory?.toDTO(),
            location: facility.location.toDTO(),
            detail: facility.detail?.toDTO()
        )
    }

    @Sendable
    func create(req: Request) async throws -> FacilityDTO {
        let facilityData = try req.content.decode(FacilityDTO.self)
        
        // Validate foreign key references
        guard let _ = try await FacilityType.find(facilityData.facilityTypeID, on: req.db) else {
            throw Abort(.badRequest, reason: "Invalid facility type ID")
        }
        
        if let tenantCategoryID = facilityData.tenantCategoryID {
            guard let _ = try await TenantCategory.find(tenantCategoryID, on: req.db) else {
                throw Abort(.badRequest, reason: "Invalid tenant category ID")
            }
        }
        
        guard let _ = try await Location.find(facilityData.locationID, on: req.db) else {
            throw Abort(.badRequest, reason: "Invalid location ID")
        }
        
        if let detailID = facilityData.detailID {
            guard let _ = try await Detail.find(detailID, on: req.db) else {
                throw Abort(.badRequest, reason: "Invalid detail ID")
            }
        }
        
        let facility = facilityData.toModel()
        try await facility.save(on: req.db)
        return facility.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> FacilityDTO {
        guard let facility = try await Facility.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updateData = try req.content.decode(FacilityDTO.self)
        
        // Validate foreign key references
        guard let _ = try await FacilityType.find(updateData.facilityTypeID, on: req.db) else {
            throw Abort(.badRequest, reason: "Invalid facility type ID")
        }
        
        if let tenantCategoryID = updateData.tenantCategoryID {
            guard let _ = try await TenantCategory.find(tenantCategoryID, on: req.db) else {
                throw Abort(.badRequest, reason: "Invalid tenant category ID")
            }
        }
        
        guard let _ = try await Location.find(updateData.locationID, on: req.db) else {
            throw Abort(.badRequest, reason: "Invalid location ID")
        }
        
        if let detailID = updateData.detailID {
            guard let _ = try await Detail.find(detailID, on: req.db) else {
                throw Abort(.badRequest, reason: "Invalid detail ID")
            }
        }
        
        facility.name = updateData.name
        facility.imagePath = updateData.imagePath
        facility.$facilityType.id = updateData.facilityTypeID
        facility.$tenantCategory.id = updateData.tenantCategoryID
        facility.$location.id = updateData.locationID
        facility.$detail.id = updateData.detailID
        
        try await facility.save(on: req.db)
        return facility.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let facility = try await Facility.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await facility.delete(on: req.db)
        return .noContent
    }
}