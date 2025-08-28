import Fluent
import SQLKit

struct CreateFacilityType: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("facility_type")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required, .sql(.check(SQLRaw("LENGTH(name) <= 100"))))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("facility_type").delete()
    }
}