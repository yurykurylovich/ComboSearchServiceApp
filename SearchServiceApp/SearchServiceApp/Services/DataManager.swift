import UIKit

class DataManager {

    static let shared = DataManager()
    
    var dataTask: URLSessionDataTask?
    
    typealias GithubResult = (error: NSError?, data: [GitHubSearchResult])
    typealias iTunesResult = (error: NSError?, data: [ItunesSearchResult])
    
    func getGithubResults(_ searchText: String, completionHandler: @escaping ((GithubResult) -> Void)) {
        guard let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
        let url = URL(string: "\(Constants.NetworkKeys.githubUrl)\(encodedText)") else { return }
        
        dataTask?.cancel()
        
        let session = URLSession.shared
        dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error as NSError?, error.code == -999 {
                DispatchQueue.main.async {
                    completionHandler((error: error, data: []))
                }
            } else if let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 {
                if let data = data {
                  do {
                      let decoder = JSONDecoder()
                      let result = try decoder.decode(GitHubResultArray.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler((error: nil, data: result.items))
                    }
                  } catch {
                      print("JSON Error: \(error)")
                      DispatchQueue.main.async {
                          completionHandler((error: nil, data: []))
                      }
                  }
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler((error: nil, data: []))
                }
            }
        })
        
        dataTask?.resume()
    }
    
    func getITunesResults(_ searchText: String, completionHandler: @escaping ((iTunesResult) -> Void)) {
        guard let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: "\(Constants.NetworkKeys.iTunesURL)\(encodedText)") else { return }
        
        dataTask?.cancel()
        
        let session = URLSession.shared
        dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error as NSError?, error.code == -999 {
                DispatchQueue.main.async {
                    completionHandler((error: error, data: []))
                }
            } else if let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 {
                if let data = data {
                  do {
                      let decoder = JSONDecoder()
                      let result = try decoder.decode(ResultArray.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler((error: nil, data: result.results))
                    }
                  } catch {
                      print("JSON Error: \(error)")
                      DispatchQueue.main.async {
                          completionHandler((error: nil, data: []))
                      }
                  }
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler((error: nil, data: []))
                }
            }
        })
        
        dataTask?.resume()
    }
}
