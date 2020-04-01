//
//  UnsplashClient.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import Foundation

class UnsplashClient: ApiClient {

	static let apiKey = "xJipitZXmyC8Ub6LCMOE8WVTUhIkmzAS_FzWgQcP440"
	static let baseUrl = "https://api.unsplash.com/"
	
	func getCollectionPhotos(collectionId: Int, page: Int, perPage: Int, completion: @escaping (Result<[Photo]>) -> Void) {
		let endpoint = UnsplashEndpoint.collectionPhotos(clientId: UnsplashClient.apiKey, collectionId: collectionId, page: page, perPage: perPage)
		get(endpoint.request, completion: completion)
	}
	
	func getPhotos(page: Int, perPage: Int, order: Order, completion: @escaping (Result<[Photo]>) -> Void) {
		let endpoint = UnsplashEndpoint.photos(clientId: UnsplashClient.apiKey, page: page, perPage: perPage, orderBy: order)
		get(endpoint.request, completion: completion)
	}
	
	func getCollections(page: Int, perPage: Int, completion: @escaping (Result<[Collection]>) -> Void) {
		let endpoint = UnsplashEndpoint.collections(clientId: UnsplashClient.apiKey, page: page, perPage: perPage)
		get(endpoint.request, completion: completion)
	}
	
	func getPhotos(searchTerm: String, page: Int, perPage: Int, order: SearchOrder, completion: @escaping (Result<PhotoSearchObject>) -> Void) {
		let endpoint = UnsplashEndpoint.photosWithSearchTerm(clientId: UnsplashClient.apiKey, searchTerm: searchTerm, page: page, perPage: perPage, orderBy: .relevant)
		get(endpoint.request, completion: completion)
	}
	
	func getCollections(searchTerm: String, page: Int, perPage: Int, completion: @escaping (Result<CollectionSearchObject>) -> Void) {
		let endpoint = UnsplashEndpoint.collectionWithSearchTerm(clientId: UnsplashClient.apiKey, searchTerm: searchTerm, page: page, perPage: perPage)
		get(endpoint.request, completion: completion)
	}
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

