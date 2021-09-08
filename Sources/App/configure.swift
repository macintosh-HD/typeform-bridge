import TypeformModel
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {

    var configuration = try PostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USER") ?? Username.get(),
        password: Environment.secret(key: "DATABASE_SECRET_FILE", fileIO: app.fileio, on: app.eventLoopGroup.next()).wait(),
        database: Environment.get("DATABASE_DB") ?? "typeform-test"
    )
    if let schema = Environment.get("DATABASE_SCHEMA") {
        configuration.searchPath = [schema]
    }
    app.databases.use(.postgres(configuration: configuration), as: .psql)
    
    app.migrations.add(FormEvent.Migration(), to: .psql)
    app.migrations.add(FormResponse.Migration(), to: .psql)
    app.migrations.add(FormScore.Migration(), to: .psql)
    app.migrations.add(FormDefinition.Migration(), to: .psql)
    app.migrations.add(FormVariable.Migration(), to: .psql)
    app.migrations.add(FormAnswer.Migration(), to: .psql)
    app.migrations.add(FormField.Migration(), to: .psql)
    app.migrations.add(PaymentAnswer.Migration(), to: .psql)
    app.migrations.add(ChoiceAnswer.Migration(), to: .psql)
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    ContentConfiguration.global.use(encoder: encoder, for: .json)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    ContentConfiguration.global.use(decoder: decoder, for: .json)
    
    // register routes
    try routes(app)
}
