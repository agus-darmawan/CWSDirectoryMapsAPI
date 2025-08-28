import Fluent
import Vapor

struct LocationDTO: Content {
    var id: Int?
    var x: Double
    var y: Double
    var z: Double?
    
    func toModel() -> Location {
        let model = Location()
        
        model.id = self.id
        model.x = self.x
        model.y = self.y
        model.z = self.z ?? 0.0
        
        return model
    }
}

extension LocationDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}