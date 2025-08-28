import Fluent
import SQLKit

struct CreateDetails: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("details")
            .field("id", .int, .identifier(auto: true))
            .field("description", .string)
            .field("phone", .string, .sql(.check(SQLRaw("LENGTH(phone) <= 20"))))
            .field("website", .string, .sql(.check(SQLRaw("LENGTH(website) <= 255"))))
            .field("unit", .string, .sql(.check(SQLRaw("LENGTH(unit) <= 50"))))
            .field("open_time", .string) 
            .field("close_time", .string) 
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("details").delete()
    }
}