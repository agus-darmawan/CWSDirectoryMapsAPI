import Fluent
import Vapor

struct FacilityDTO: Content {
    var id: Int?
    var name: String
    var imagePath: String?
    var facilityTypeID: Int
    var tenantCategoryID: Int?
    var locationID: Int
    var detailID: Int?
    
    func toModel() -> Facility {
        let model = Facility()
        
        model.id = self.id
        model.name = self.name
        model.imagePath = self.imagePath
        model.$facilityType.id = self.facilityTypeID
        model.$tenantCategory.id = self.tenantCategoryID
        model.$location.id = self.locationID
        model.$detail.id = self.detailID
        
        return model
    }
}

// Extended DTO with joined data for detailed responses
struct FacilityWithDetailsDTO: Content {
    var id: Int?
    var name: String
    var imagePath: String?
    var facilityType: FacilityTypeDTO
    var tenantCategory: TenantCategoryDTO?
    var location: LocationDTO
    var detail: DetailDTO?
}

extension FacilityDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.imagePath == rhs.imagePath &&
        lhs.facilityTypeID == rhs.facilityTypeID &&
        lhs.tenantCategoryID == rhs.tenantCategoryID &&
        lhs.locationID == rhs.locationID &&
        lhs.detailID == rhs.detailID
    }
}