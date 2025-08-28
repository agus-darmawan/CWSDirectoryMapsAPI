import Fluent
import Vapor

struct TenantCategoryDTO: Content {
    var id: Int?
    var name: String
    
    func toModel() -> TenantCategory {
        let model = TenantCategory()
        
        model.id = self.id
        model.name = self.name
        
        return model
    }
}

extension TenantCategoryDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}