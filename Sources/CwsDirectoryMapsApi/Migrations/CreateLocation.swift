import Fluent

struct CreateLocation: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("location")
            .field("id", .int, .identifier(auto: true))
            .field("x", .double, .required)
            .field("y", .double, .required)
            .field("z", .double, .sql(.default(0.0)))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("location").delete()
    }
}