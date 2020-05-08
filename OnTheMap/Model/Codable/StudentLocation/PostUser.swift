//
//  PostUser.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-07.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import Foundation

struct PostUser: Codable {
	let uniqueKey : String
	let firstName : String
	let lastName  : String
	let mapString : String
	let mediaURL  : String
	let latitude  : Double
	let longitude : Double
}
