//
//  UnsplashClient.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import Foundation

class UnsplashClient: ApiClient {
	static let baseUrl = "https://api.unsplash.com/"
	static let apiKey = "xJipitZXmyC8Ub6LCMOE8WVTUhIkmzAS_FzWgQcP440"
	
	func fetch(_ endpoint: UnsplashEndpoint, completion: @escaping (Result<[Photo]>) -> Void) {
		let request = endpoint.request
		get(request, completion: completion)
	}
	
	func fetchCollections(_ endpoint: UnsplashEndpoint, completion: @escaping (Result<[Collection]>) -> Void) {
		let request = endpoint.request
		get(request, completion: completion)
	}
	
	func fetchCollectionPhotos(_ endpoint: UnsplashEndpoint, completion: @escaping (Result<[Photo]>) -> Void) {
		let request = endpoint.request
		get(request, completion: completion)
	}
	
}
