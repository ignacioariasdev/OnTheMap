//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-04.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import Foundation


struct UserCredentials: Codable {
	let email: String
	let password: String
}

struct LoginRequest: Codable {

	let loginAPI: UserCredentials

	init(email: String, password: String) {
		loginAPI = UserCredentials(email: email, password: password)
	}
}
