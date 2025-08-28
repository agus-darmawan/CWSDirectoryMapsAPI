import Fluent
import struct Foundation.UUID
import struct Foundation.Date

final class Detail: Model, @unchecked Sendable {
    static let schema = "details"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @OptionalField(key: "description")
    var description: String?

    @OptionalField(key: "phone")
    var phone: String?

    @OptionalField(key: "website")
    var website: String?

    @OptionalField(key: "unit")
    var unit: String?

    @OptionalField(key: "open_time")
    var openTime: String? // Using String for TIME type

    @OptionalField(key: "close_time")
    var closeTime: String? // Using String for TIME type

    @Children(for: \.$detail)
    var facilities: [Facility]

    init() { }

    init(id: Int? = nil, 
         description: String? = nil,
         phone: String? = nil,
         website: String? = nil,
         unit: String? = nil,
         openTime: String? = nil,
         closeTime: String? = nil) {
        self.id = id
        self.description = description
        self.phone = phone
        self.website = website
        self.unit = unit
        self.openTime = openTime
        self.closeTime = closeTime
    }
    
    func toDTO() -> DetailDTO {
        .init(
            id: self.id,
            description: self.description,
            phone: self.phone,
            website: self.website,
            unit: self.unit,
            openTime: self.openTime,
            closeTime: self.closeTime
        )
    }
}