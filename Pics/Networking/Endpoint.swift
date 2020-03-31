//
//  Endpoint.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import Foundation

protocol Endpoint {
	var baseUrl: String { get }
	var path: String { get }
	var urlParameters: [URLQueryItem] { get }
}

extension Endpoint {
	var urlComponent: URLComponents {
		var urlComponent = URLComponents(string: baseUrl)
		urlComponent?.path = path
		urlComponent?.queryItems = urlParameters
		return urlComponent!
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

enum UnsplashEndpoint: Endpoint {
	
	case photos(clientId: String, page: Int, perPage: Int, orderBy: Order)
	case collections(clientId: String, page: Int, perPage: Int)
	
	var baseUrl: String {
		return "https://api.unsplash.com"
	}
	
	var path: String {
		switch self {
		case .photos:
			return "/photos"
		case .collections:
			return "/collections"
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
		}
	}
}
