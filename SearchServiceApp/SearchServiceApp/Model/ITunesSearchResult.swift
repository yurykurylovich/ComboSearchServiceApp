import Foundation

class ResultArray: Codable {
    var resultCount = 0
    var results = [ItunesSearchResult]()
    
}

class ItunesSearchResult: Codable, CustomStringConvertible {
    
    var artistName: String? = ""
    var trackName: String? = ""
    var imageSmall = ""

    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case artistName, trackName
        }
    
    var description: String {
        return "Name: \(name ?? ""), Artist Name: \(artistName ?? "None")\n"
    }
}

extension ItunesSearchResult: SearchResultObject {
    var name: String? {
        return trackName
    }
    
    var info: String? {
        return artistName
    }
    
    var imageUrl: String? {
        return imageSmall
    }
    
}
