//
//  UnsplashImage.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import Foundation

class PhotoSearchObject: Codable {
	let total: Int
	let results: [Photo]
}

struct Photo: Codable {
	let id: String
	let urls: Urls
	let width: Int
	let height: Int
	let user: User
}

struct User: Codable {
	let username: String
	let name: String
}

struct Urls: Codable {
	let raw: String
	let full: String
	let regular: String
	let small: String
	let thumb: String
}

extension Photo: Hashable {
	static func == (lhs: Photo, rhs: Photo) -> Bool {
		return lhs.id == rhs.id
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
