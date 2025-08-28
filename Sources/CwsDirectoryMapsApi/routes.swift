import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works! by me trust me"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: TodoController())
}
