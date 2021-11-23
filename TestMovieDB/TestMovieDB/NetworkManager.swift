
import UIKit

let apiKey = "f07102cf3fe668a526bf543b8b0220ea"
let baseUrl = "https://api.themoviedb.org/3/"
let imageBaseUrl = "https://image.tmdb.org/t/p/w200/"


let movieList = "movie/popular"
let genreList = "genre/movie/list"
let movieDetail = "movie/%d"

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
typealias Completion = (_ response: Any, _ status: Bool) -> Void

struct NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private func sendRequest(type: HttpMethod, parameters: [String: Any], urlString: String, handler: @escaping Completion) {
        
        let headers = [
            "content-type": "application/json",
            "accept": "application/json",
        ]
        
        let urlString = String(format: (urlString.contains("?") ? "%@&api_key=%@" : "%@?api_key=%@"), urlString, apiKey).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var request = URLRequest(url:  URL(string: urlString)!)
        request.allHTTPHeaderFields = headers
        
        if type == .post {
            var postData:Data?
            
            do {
                try  postData = JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                
            }
            request.httpMethod = type.rawValue
            request.httpBody = postData
        } else {
            request.httpMethod = type.rawValue
        }
        print(urlString)
        print(parameters)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if (error != nil) {
                print(error ?? "null error")
                handler(String(), false)
            } else {
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        do {
                            let jsonString = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            print(jsonString)
                        } catch {
                            
                        }
                        handler(data ?? "null data", true)
                        break
                    default:
                        handler(data ?? "null data", false)
                        break
                    }
                }
                
            }
        }.resume()
    }
    
    func getMovieList(page: Int, handler: @escaping Completion) {
        sendRequest(type: .get, parameters: [:], urlString: String(format: "\(baseUrl+movieList)?page=%d", page)) { (data, status) in
            if status {
                do {
                    let response = try JSONDecoder().decode(MoviesList.self, from: data as! Data)
                    handler(response, true)
                } catch let error {
                    handler(error, false)
                }
            } else {
                handler(data, false)
            }
        }
    }
    
    func getGenres(handler: @escaping Completion) {
        sendRequest(type: .get, parameters: [:], urlString: baseUrl+genreList) { (data, status) in
            if status {
                do {
                    let response = try JSONDecoder().decode(GenresList.self, from: data as! Data)
                    handler(response, true)
                } catch let error {
                    handler(error, false)
                }
            } else {
                handler(data, false)
            }
        }
    }
    
    func getMovieDetails(_ movieId: Int, handler: @escaping Completion) {
      sendRequest(type: .get, parameters: [:], urlString: baseUrl+String(format: movieDetail, movieId)) { (data, status) in
            if status {
                do {
                    let response = try JSONDecoder().decode(MovieDetail.self, from: data as! Data)
                    handler(response, true)
                } catch let error {
                    handler(error, false)
                }
            } else {
                handler(data, false)
            }
        }
    }
}
