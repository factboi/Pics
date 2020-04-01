//
//  Endpoint.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import Foundation

protocol Endpoint {
	var host: String { get }
	var scheme: String { get }
	var path: String { get }
	var urlParameters: [URLQueryItem] { get }
}

extension Endpoint {
	var urlComponent: URLComponents {
		var urlComponent = URLComponents()
		urlComponent.scheme = scheme
		urlComponent.host = host
		urlComponent.path = path
		urlComponent.queryItems = urlParameters
		return urlComponent
	}
	
	var request: URLRequest {
		return URLRequest(url: urlComponent.url!)
	}
	
}

enum Order: String {
	case latest
	case oldest
	case popular
}

enum SearchOrder: String {
	case latest, relevant
}

enum UnsplashEndpoint: Endpoint {
	
	case photos(clientId: String, page: Int, perPage: Int, orderBy: Order)
	
	case collections(clientId: String, page: Int, perPage: Int)
	
	case collectionPhotos(clientId: String, collectionId: Int, page: Int, perPage: Int)
	
	case photosWithSearchTerm(clientId: String, searchTerm: String, page: Int, perPage: Int, orderBy: SearchOrder)
	
	case collectionWithSearchTerm(clientId: String, searchTerm: String, page: Int, perPage: Int)
	
	var host: String {
		return "api.unsplash.com"
	}
	
	var scheme: String {
		return "https"
	}
	
	var path: String {
		switch self {
		case .photos:
			return "/photos"
		case .collections:
			return "/collections"
		case .collectionPhotos(_, let collectionId, _, _):
			return "/collections/\(collectionId)/photos"
		case .photosWithSearchTerm:
			return "/search/photos"
		case .collectionWithSearchTerm:
			return "/search/collections"
		}
	}
	
	var urlParameters: [URLQueryItem] {
		switch self {
		case .photos(let clientId, let page, let perPage, let order):
			return [
				URLQueryItem(name: "client_id", value: clientId),
				URLQueryItem(name: "page", value: "\(page)"),
				URLQueryItem(name: "per_page", value: "\(perPage)"),
				URLQueryItem(name: "order_by", value: order.rawValue),
			]
		case .collections(let clientId, let page, let perPage):
			return [
				URLQueryItem(name: "client_id", value: clientId),
				URLQueryItem(name: "page", value: "\(page)"),
				URLQueryItem(name: "per_page", value: "\(perPage)"),
			]
		case .collectionPhotos(let clientId, let collectionId, let page, let perPage):
			return [
				URLQueryItem(name: "client_id", value: clientId),
				URLQueryItem(name: "id", value: "\(collectionId)"),
				URLQueryItem(name: "page", value: "\(page)"),
				URLQueryItem(name: "per_page", value: "\(perPage)"),
			]
		case .photosWithSearchTerm(let clientId, let searchTerm, let page, let perPage, let orderBy):
			return [
				URLQueryItem(name: "client_id", value: clientId),
				URLQueryItem(name: "query", value: searchTerm),
				URLQueryItem(name: "page", value: "\(page)"),
				URLQueryItem(name: "per_page", value: "\(perPage)"),
				URLQueryItem(name: "order_by", value: orderBy.rawValue),
			]
		case .collectionWithSearchTerm(let clientId, let searchTerm, let page, let perPage):
			return [
				URLQueryItem(name: "client_id", value: clientId),
				URLQueryItem(name: "query", value: searchTerm),
				URLQueryItem(name: "page", value: "\(page)"),
				URLQueryItem(name: "per_page", value: "\(perPage)"),
			]
		}
	}
}
