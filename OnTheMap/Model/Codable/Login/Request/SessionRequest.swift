//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-06.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import Foundation

struct User: Codable {
	let username: String
	let password: String
}

struct SessionRequest: Codable {
	let user: User

	enum CodingKeys: String, CodingKey {
		case user = "udacity"
	}
}
