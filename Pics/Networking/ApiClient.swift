//
//  ApiClient.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
	case success(T)
	case error(ApiError)
}

enum ApiError: Error {
	case unknown, jsonDecoder
}

protocol ApiClient {
	func get<T: Decodable>(_ request: URLRequest, completion: @escaping(Result<[T]>) -> Void)
}

extension ApiClient {
	func get<T: Decodable>(_ request: URLRequest, completion: @escaping(Result<[T]>) -> Void) {
		AF.request(request).responseJSON { (response) in
			guard let data = response.data else {
				completion(.error(.unknown))
				return
			}
			guard let value = try? JSONDecoder().decode([T].self, from: data) else {
				completion(.error(.jsonDecoder))
				return
			}
			DispatchQueue.main.async {
				completion(.success(value))
			}
		}
	}
}

