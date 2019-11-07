//
//  APIRequests.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 05/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

private struct NilCodable: Codable {
}

public enum HttpMethods: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
}

public enum TaskAnswer<T> {
    case result(T)
    case error(Error)
}

public class APIRequests {
    private init() {
    }

    private static func createRequest(url: String, method: HttpMethods) -> NSMutableURLRequest? {
        guard let URL = URL(string: url) else {
            return nil
        }
        let request = NSMutableURLRequest(url: URL)
        request.httpMethod = method.rawValue
        return request
    }

    public static func getRequest(url: String, header: [String: String]? = nil, completion: @escaping (TaskAnswer<Any>) -> Void) {
        getRequest(url: url, decodableType: NilCodable.self, header: header, completion: completion)
    }

    public static func getRequest<T: Codable>(
        url: String,
        decodableType: T.Type,
        header: [String: String]? = nil,
        completion: @escaping (TaskAnswer<Any>) -> Void ) {

        guard let request = createRequest(url: url, method: .get) else {
            completion(TaskAnswer.error(NotURLError(title: nil, description: "Couldn't parse argument to URL")))
            return
        }

        for headerParam in header ?? [:] {
            request.addValue(headerParam.value, forHTTPHeaderField: headerParam.key)
        }
        createTask(request: request as URLRequest, decodableType: decodableType, completion: completion).resume()
    }

    public static func postRequest(url: String, method: HttpMethods = .post, header: [String: String]? = nil, params: [String: Any], completion:
        @escaping (TaskAnswer<Any>) -> Void) {
        postRequest(url: url, params: params, decodableType: NilCodable.self, completion: completion)
    }

    public static func postRequest<T: Codable>(
        url: String,
        params: [String: Any],
        method: HttpMethods = .post,
        header: [String: String]? = nil,
        decodableType: T.Type,
        completion: @escaping (TaskAnswer<Any>) -> Void) {

        guard let request = createRequest(url: url, method: method) else {
            completion(TaskAnswer.error(NotURLError(title: nil, description: "Couldn't parse argument to URL")))
            return
        }

        for headerParam in header ?? [:] {
            request.addValue(headerParam.value, forHTTPHeaderField: headerParam.key)
        }
        let postString = params.percentEscaped()
        request.httpBody = postString.data(using: String.Encoding.utf8)
        createTask(request: request as URLRequest, decodableType: decodableType, completion: completion).resume()
    }

    public static func createTask<T: Codable>(request: URLRequest, decodableType: T.Type, completion:
        @escaping (TaskAnswer<Any>) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(TaskAnswer.result([:]))
                return
            }
            do {
                // A resposta chegou
                if decodableType != NilCodable.self {
                    let response = try JSONDecoder().decode(decodableType, from: data)
                    completion(TaskAnswer.result(response))
                } else {
                    let response = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(TaskAnswer.result(response))
                }
            } catch let error as NSError {
                // Houve um erro na conversão de tipo ou comunicaçao com servidor
                completion(TaskAnswer.error(error))
            }
        }
        return task
    }

}
