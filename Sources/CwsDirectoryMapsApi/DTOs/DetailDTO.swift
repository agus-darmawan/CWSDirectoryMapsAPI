import Fluent
import Vapor

struct DetailDTO: Content {
    var id: Int?
    var description: String?
    var phone: String?
    var website: String?
    var unit: String?
    var openTime: String?
    var closeTime: String?
    
    func toModel() -> Detail {
        let model = Detail()
        
        model.id = self.id
        model.description = self.description
        model.phone = self.phone
        model.website = self.website
        model.unit = self.unit
        model.openTime = self.openTime
        model.closeTime = self.closeTime
        
        return model
    }
}

extension DetailDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && 
        lhs.description == rhs.description &&
        lhs.phone == rhs.phone &&
        lhs.website == rhs.website &&
        lhs.unit == rhs.unit &&
        lhs.openTime == rhs.openTime &&
        lhs.closeTime == rhs.closeTime
    }
}