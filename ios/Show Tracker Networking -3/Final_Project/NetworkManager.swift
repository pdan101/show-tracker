import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static let host = "https://prithwishjoyceshowtracker2.herokuapp.com"
    
    static func getUser(username: String, completion: @escaping (User) -> Void) {
        let parameters: [String: String] = [
            "username" : username
        ]
        AF.request("\(host)/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let user = try? jsonDecoder.decode(User.self, from: data) {
                    print(user)
                    completion(user)
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    static func getWatchlist(userId: Int, completion: @escaping ([Show]) -> Void) {
        AF.request("\(host)/api/watchlist/\(userId)/", method: .get, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let showResponse = try? jsonDecoder.decode(ShowResponse.self, from: data) {
                    let shows = showResponse.shows
                    print(shows)
                    completion(shows)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func makePostWatchlist(name: String, year_released: Int, start_date: String, finished: Bool, genre: String, user_id: Int, completion: @escaping (Show) -> Void) {
        let parameters: [String : Any] = [
            "name" : name,
            "year_released" : year_released,
            "start_date" : start_date,
            "finished" : finished,
            "genre" : genre,
        ]
        AF.request("\(host)/api/watchlist/\(user_id)/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let show = try? jsonDecoder.decode(Show.self, from: data) {
                    print(show)
                    completion(show)
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    static func deleteCurrentWatch(showID: Int, userID: Int, completion: @escaping (Show) -> Void) {
        AF.request("\(host)/api/watchlist/\(showID)/\(userID)/", method: .delete, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let show = try? jsonDecoder.decode(Show.self, from: data) {
                    completion(show)
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    static func getPlanWatchlist(userId: Int, completion: @escaping ([Show]) -> Void) {
        AF.request("\(host)/api/planlist/\(userId)/", method: .get, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let showResponse = try? jsonDecoder.decode(ShowResponse.self, from: data) {
                    let shows = showResponse.shows
                    print(shows)
                    completion(shows)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func makePostPlanList(name: String, year_released: Int, genre: String, user_id: Int, completion: @escaping (Show) -> Void) {
        let parameters: [String : Any] = [
            "name" : name,
            "year_released" : year_released,
            "genre" : genre,
        ]
        AF.request("\(host)/api/planlist/\(user_id)/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let show = try? jsonDecoder.decode(Show.self, from: data) {
                    print(show)
                    completion(show)
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    static func deletePlanWatch(showID: Int, userID: Int, completion: @escaping (Show) -> Void) {
        AF.request("\(host)/api/planlist/\(showID)/\(userID)/", method: .delete, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let show = try? jsonDecoder.decode(Show.self, from: data) {
                    completion(show)
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
}
