//
//  UnsplashImage.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import Foundation

struct Photo: Decodable {
	let id: String
	let urls: URLS
	let width: Int
	let height: Int
	let user: User
}

struct User: Decodable {
	let username: String
}

struct URLS: Decodable {
	let raw: String
	let full: String
	let regular: String
	let small: String
	let thumb: String
}
