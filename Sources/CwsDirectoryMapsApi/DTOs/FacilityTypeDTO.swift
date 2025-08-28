import Fluent
import Vapor

struct FacilityTypeDTO: Content {
    var id: Int?
    var name: String
    
    func toModel() -> FacilityType {
        let model = FacilityType()
        
        model.id = self.id
        model.name = self.name
        
        return model
    }
}

extension FacilityTypeDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}