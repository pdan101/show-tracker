//
//  Show.swift
//  Final_Project
//
//  Created by Richard Jin on 11/20/21.
//

import Foundation

class Show: Codable {
    
    var name: String
    var genre: String
    var year: Int
    var rating: String
    var watched: Bool
    
    init(name: String, genre: String, year: Int, rating: String, watched: Bool ) {
        self.name = name
        self.genre = genre
        self.rating = rating
        self.year = year
        self.watched = watched
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getWatchStatus() -> Bool {
        return self.watched
    }
    
    func getGenre() -> String {
        return self.genre
    }
    
    func getRating() -> String {
        return self.rating
    }
    
    func getYear() -> String {
        return String(self.year)
    }
}
