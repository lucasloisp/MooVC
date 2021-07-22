//
//  APIClient.swift
//  AFTest
//
//  Created by German Rodriguez on 7/20/21.
//
// swiftlint:disable line_length

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class APIClient {

    typealias APIResult = Result<Any, Error>
    typealias APIResponse = (APIResult) -> Void

    static let shared = APIClient()

    private init() { }

    func request(request: APIRoute, onCompletion: @escaping APIResponse) {
        AF.request(request).validate().responseJSON { response -> Void in
            self.handle(response: response, onCompletion: onCompletion)
        }
    }

    func requestItem<T: BaseMappable>(request: APIRoute, responseKey: String? = nil, onCompletion: @escaping (Result<T, Error>) -> Void) {
        AF.request(request).validate().responseObject { (response: DataResponse<T, AFError>) in
            switch response.result {
            case .success(let object): onCompletion(.success(object))
            case .failure(let error as Error): onCompletion(.failure(error))
            }
        }
    }

    func requestItems<T: BaseMappable>(request: APIRoute, responseKey: String? = nil, onCompletion: @escaping (Result<[T], Error>) -> Void) {
        AF.request(request).validate().responseArray { (response: DataResponse<[T], AFError>) in
            switch response.result {
            case .success(let array): onCompletion(.success(array))
            case .failure(let error as Error): onCompletion(.failure(error))
            }
        }
    }

    private func handle(response: AFDataResponse<Any>, onCompletion: @escaping APIResponse) {
        switch response.result {
        case .success(let value):
            onCompletion(.success(value))
        case .failure(let error as NSError):
            if response.response?.statusCode == 403 || response.response?.statusCode == 401 {
                // Handle auth failure
            } else {
                onCompletion(.failure(error))
            }
        default:
            break
        }
    }
}
