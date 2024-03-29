//
//  API.swift
//  Tutorials
//
//  Created by kor45cw on 10/08/2019.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import Alamofire

class API {
    static let shared: API = API()
    
    private var request: DataRequest? {
        didSet {
            oldValue?.cancel()
        }
    }
    private var reachability: NetworkReachabilityManager!

    private init() {
        monitorReachability()
    }
    
    private func monitorReachability() {
        reachability = NetworkReachabilityManager(host: "www.apple.com")

        reachability.listener = { status in
            print("Reachability Status Changed: \(status)")
        }

        reachability.startListening()
    }
    
    func get1(completionHandler: @escaping (Result<[UserData], Error>) -> Void) {
        self.request = AF.request("\(Config.baseURL)/posts")
                        .responseDecodable { (response: DataResponse<[UserData]>) in
                            switch response.result {
                            case .success(let userDatas):
                                completionHandler(.success(userDatas))
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
    }
    
    func get2(completionHandler: @escaping (Result<[UserData], Error>) -> Void) {
        let parameters: Parameters = ["userId": 1]
        self.request = AF.request("\(Config.baseURL)/posts", method: .get, parameters: parameters, encoding: URLEncoding.default)
                        .responseDecodable { (response: DataResponse<[UserData]>) in
                            switch response.result {
                            case .success(let userDatas):
                                completionHandler(.success(userDatas))
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
    }
    
    func post(completionHandler: @escaping (Result<[UserData], Error>) -> Void) {
        let userData = PostUserData()
        self.request = AF.request("\(Config.baseURL)/posts", method: .post, parameters: userData)
                        .responseDecodable { (response: DataResponse<PostUserData>) in
                            switch response.result {
                            case .success(let userData):
                                completionHandler(.success([userData.toUserData()]))
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
    }
    
    func put(completionHandler: @escaping (Result<[UserData], Error>) -> Void) {
        let userData = PostUserData(id: 1)
        self.request = AF.request("\(Config.baseURL)/posts/1", method: .put, parameters: userData)
                        .responseDecodable { (response: DataResponse<PostUserData>) in
                            switch response.result {
                            case .success(let userData):
                                completionHandler(.success([userData.toUserData()]))
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
    }
    
    func patch(completionHandler: @escaping (Result<[UserData], Error>) -> Void) {
        let userData = PostUserData(id: 1)
        self.request = AF.request("\(Config.baseURL)/posts/1", method: .patch, parameters: userData)
                        .responseDecodable { (response: DataResponse<PatchUserData>) in
                            switch response.result {
                            case .success(let userData):
                                completionHandler(.success([userData.toUserData()]))
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
    }
    
    func delete(completionHandler: @escaping (Result<[UserData], Error>) -> Void) {
        self.request = AF.request("\(Config.baseURL)/posts/1", method: .delete)
                        .response { response in
                            switch response.result {
                            case .success:
                                completionHandler(.success([UserData(userId: -1, id: -1, title: "DELETE", body: "SUCCESS")]))
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
    }
}
