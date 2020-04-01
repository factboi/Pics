//
//  UnsplashCollection.swift
//  Pics
//
//  Created by factboii on 31.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import Foundation

class CollectionSearchObject: Codable {
	let total: Int
	let results: [Collection]
}

struct Collection: Codable {
	let id: Int
	let title: String
	let coverPhoto: CoverPhoto
	let user: User
	let links: Links
	private enum CodingKeys: String, CodingKey {
		case id, title, user, links
		case coverPhoto = "cover_photo"
	}
}

struct Links: Codable {
	let photos: String
}

struct CoverPhoto: Codable {
	let id: String
	let urls: Urls
}

extension Collection: Hashable {
	static func == (lhs: Collection, rhs: Collection) -> Bool {
		return lhs.id == rhs.id
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

