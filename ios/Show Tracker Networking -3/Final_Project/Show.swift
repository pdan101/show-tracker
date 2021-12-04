import Foundation

class Show: Codable {
    
    
    var id: Int
    var name: String
    var genre: String
    var year_released: Int
    var start_date: String?
    var finished: Bool?
    var image_url: String
    
    init(id: Int, name: String, genre: String, year_released: Int, start_date: String, finished: Bool, image_url: String) {
        self.id = id
        self.name = name
        self.genre = genre
        self.year_released = year_released
        self.start_date = start_date
        self.finished = finished
        self.image_url = image_url
    }
    
    init(id: Int, name: String, genre: String, year_released: Int, image_url: String) {
        self.id = id
        self.name = name
        self.genre = genre
        self.year_released = year_released
        self.start_date = nil
        self.finished = nil
        self.image_url = image_url
    }
    
    func getName() -> String {
        return self.name
    }

    func getGenre() -> String {
        return self.genre
    }

    func getYear() -> Int {
        return self.year_released
    }

    func getStart() -> String? {
        return self.start_date
    }

    func getFinished() -> Bool? {
        return self.finished
    }
    func getImage() -> String {
        return self.image_url
    }
    func getID() -> Int {
        return self.id
    }
}

struct ShowResponse : Codable {
    var shows : [Show]
}

struct DeleteResponse : Codable {
    var show : Show
}
