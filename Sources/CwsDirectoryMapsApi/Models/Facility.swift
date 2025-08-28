import Fluent
import struct Foundation.UUID

final class Facility: Model, @unchecked Sendable {
    static let schema = "facilities"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "name")
    var name: String

    @OptionalField(key: "image_path")
    var imagePath: String?

    @Parent(key: "facility_type_id")
    var facilityType: FacilityType

    @OptionalParent(key: "tenant_category_id")
    var tenantCategory: TenantCategory?

    @Parent(key: "location_id")
    var location: Location

    @OptionalParent(key: "detail_id")
    var detail: Detail?

    init() { }

    init(id: Int? = nil,
         name: String,
         imagePath: String? = nil,
         facilityTypeID: Int,
         tenantCategoryID: Int? = nil,
         locationID: Int,
         detailID: Int? = nil) {
        self.id = id
        self.name = name
        self.imagePath = imagePath
        self.$facilityType.id = facilityTypeID
        self.$tenantCategory.id = tenantCategoryID
        self.$location.id = locationID
        self.$detail.id = detailID
    }
    
    func toDTO() -> FacilityDTO {
        .init(
            id: self.id,
            name: self.name,
            imagePath: self.imagePath,
            facilityTypeID: self.$facilityType.id,
            tenantCategoryID: self.$tenantCategory.id,
            locationID: self.$location.id,
            detailID: self.$detail.id
        )
    }
}