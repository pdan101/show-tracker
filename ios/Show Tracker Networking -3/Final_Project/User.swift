import Alamofire
import Foundation

class User : Codable{
    private var id: Int
    private var username: String
    
    
    init (id: Int, username: String) {
        self.id = id
        self.username = username
    }
    
    func getID() -> Int {
        return self.id
    }
}

