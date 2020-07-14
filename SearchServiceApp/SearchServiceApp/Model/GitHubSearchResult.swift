import Foundation

class GitHubResultArray: Codable {
    var total_count = 0
    var items = [GitHubSearchResult]()
}

class GitHubSearchResult: Codable, CustomStringConvertible {
    
    
    var login: String? = ""
    var avatar_url: String? = ""
    var url: String? = ""
    
    var description: String {
        return "Login: \(name ?? ""), URL: \(url ?? "None"), avatar: \(avatar_url ?? "None")"
    }
}

extension GitHubSearchResult: SearchResultObject {
    var name: String? {
        return login
    }
    
    var info: String? {
        return url
    }
    
    var imageUrl: String? {
        return avatar_url
    }
    
}



