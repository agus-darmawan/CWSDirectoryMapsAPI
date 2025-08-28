import Fluent
import struct Foundation.UUID

final class Location: Model, @unchecked Sendable {
    static let schema = "location"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "x")
    var x: Double

    @Field(key: "y")
    var y: Double

    @Field(key: "z")
    var z: Double

    @Children(for: \.$location)
    var facilities: [Facility]

    init() { }

    init(id: Int? = nil, x: Double, y: Double, z: Double = 0.0) {
        self.id = id
        self.x = x
        self.y = y
        self.z = z
    }
    
    func toDTO() -> LocationDTO {
        .init(
            id: self.id,
            x: self.x,
            y: self.y,
            z: self.z
        )
    }
}