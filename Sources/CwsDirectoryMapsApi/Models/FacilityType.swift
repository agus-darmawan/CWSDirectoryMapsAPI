import Fluent
import struct Foundation.UUID

final class FacilityType: Model, @unchecked Sendable {
    static let schema = "facility_type"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "name")
    var name: String

    @Children(for: \.$facilityType)
    var facilities: [Facility]

    init() { }

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    func toDTO() -> FacilityTypeDTO {
        .init(
            id: self.id,
            name: self.name
        )
    }
}