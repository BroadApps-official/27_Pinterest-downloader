import Alamofire
import SwiftUI

struct APIResponse: Decodable {
    let id: String
    let error: String?
    let items: [Item]
}

struct Item: Decodable {
    let author: String?
    let title: String?
    let error: String?
    let width: Int?
    let height: Int?
    let url: String
    let thumbnail: String?
    let type: String
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://backend.innovatewebsolutions.shop/api/task"
    
    private let appBundle = "com.kha.p1nt3r3std0wn"
    private let userID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown_id"
    
    func postTask(urls: [String], completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let parameters: [String: Any] = [
            "user_id": userID,
            "app_bundle": appBundle,
            "urls": urls
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: APIResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getTask(taskID: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
            let url = "\(baseURL)/\(taskID)"
            
            AF.request(url, method: .get)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                        completion(.success(decoded))
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
