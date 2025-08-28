import Fluent
import SQLKit

struct CreateFacilities: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("facilities")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required, .sql(.check(SQLRaw("LENGTH(name) <= 255"))))
            .field("image_path", .string)
            .field("facility_type_id", .int, .required, .references("facility_type", "id", onDelete: .restrict))
            .field("tenant_category_id", .int, .references("tenant_categories", "id", onDelete: .setNull))
            .field("location_id", .int, .required, .references("location", "id", onDelete: .cascade))
            .field("detail_id", .int, .references("details", "id", onDelete: .setNull))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("facilities").delete()
    }
}