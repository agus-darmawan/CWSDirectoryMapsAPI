import Fluent
import SQLKit

struct CreateTenantCategories: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("tenant_categories")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required, .sql(.check(SQLRaw("LENGTH(name) <= 100"))))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("tenant_categories").delete()
    }
}