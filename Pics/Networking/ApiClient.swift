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
	func getPhotos(page: Int, perPage: Int, order: Order, completion: @escaping (Result<[Photo]>) -> Void)
	func getCollections(page: Int, perPage: Int, completion: @escaping (Result<[Collection]>) -> Void)
	func getCollectionPhotos(collectionId: Int, page: Int, perPage: Int, completion: @escaping (Result<[Photo]>) -> Void)
	func getPhotos(searchTerm: String, page: Int, perPage: Int, order: SearchOrder, completion: @escaping (Result<PhotoSearchObject>) -> Void)
	func getCollections(searchTerm: String , page: Int, perPage: Int, completion: @escaping (Result<CollectionSearchObject>) -> Void)
	func get<T: Codable>(_ request: URLRequest, completion: @escaping(Result<T>) -> Void)
}

extension ApiClient {
	func get<T: Codable>(_ request: URLRequest, completion: @escaping(Result<T>) -> Void) {
		AF.request(request).responseJSON { (response) in
			guard let data = response.data else {
				completion(.error(.unknown))
				return
			}
			guard let value = try? JSONDecoder().decode(T.self, from: data) else {
				completion(.error(.jsonDecoder))
				return
			}
			DispatchQueue.main.async {
				completion(.success(value))
			}
		}
	}
	
	
	
}
