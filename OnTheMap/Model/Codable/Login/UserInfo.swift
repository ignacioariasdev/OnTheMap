//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-07.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
	let userName: String
	let lastName: String

	enum CodingKeys: String, CodingKey {
		case userName = "user_name"
		case lastName
	}
}
