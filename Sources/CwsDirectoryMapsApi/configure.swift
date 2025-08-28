import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // Serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Database config
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    do {
        if let sql = app.db(.psql) as? any SQLDatabase {
            try await sql.raw("SELECT 1").run()
        } else {
            app.logger.error("❌ Failed to cast database to SQLDatabase.")
        }
        app.logger.info("✅ Successfully connected to Postgres database.")
    } catch {
        app.logger.error("❌ Failed to connect to Postgres database: \(error.localizedDescription)")
    }

    // Migrations
    app.migrations.add(CreateFacilityType())
    app.migrations.add(CreateTenantCategories())
    app.migrations.add(CreateLocation())
    app.migrations.add(CreateDetails())
    app.migrations.add(CreateFacilities())

    // Run migrations
    try await app.autoMigrate()
    app.logger.info("✅ Migrations completed.")


    // Register routes
    try routes(app)
}
