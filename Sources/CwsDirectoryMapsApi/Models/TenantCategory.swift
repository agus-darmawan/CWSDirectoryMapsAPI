import Fluent
import struct Foundation.UUID

final class TenantCategory: Model, @unchecked Sendable {
    static let schema = "tenant_categories"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "name")
    var name: String

    @Children(for: \.$tenantCategory)
    var facilities: [Facility]

    init() { }

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    func toDTO() -> TenantCategoryDTO {
        .init(
            id: self.id,
            name: self.name
        )
    }
}