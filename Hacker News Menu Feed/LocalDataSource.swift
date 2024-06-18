import Foundation

class LocalDataSource {
    
    public static func saveShowOnlyIcon(value: Bool){
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: "ShowOnlyIcon")
        }
    }
    
    public static func getShowOnlyIcon() -> Bool {
        var result: Bool = false
        
        if let data = UserDefaults.standard.data(forKey: "ShowOnlyIcon") {
            if let decoded = try? JSONDecoder().decode(Bool.self, from: data) {
                result = decoded
            }
        }
        
        return result
    }
}
