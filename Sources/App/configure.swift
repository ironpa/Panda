import Vapor
import Leaf
import FluentPostgreSQL
import Authentication

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Configure the rest of your application here
    
    //Registere middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(FileMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    //Registering Leaf service
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    //Registering Fluent PostgreSQL
    try services.register(FluentPostgreSQLProvider())
    
    // Initializing migrations
    var migrations = MigrationConfig()
    
    //Here you can add migrations
    migrations.add(model: User.self, database: .psql)
    
    //Registering migrations
    services.register(migrations)
    
    try services.register(AuthenticationProvider())
    
    
    //Database configuration
    var databases = DatabasesConfig()
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost", username: "ireneuszparysz", database: "ProjektPanda")
    databases.add(database: PostgreSQLDatabase(config: databaseConfig), as: .psql)
    services.register(databases)
}
