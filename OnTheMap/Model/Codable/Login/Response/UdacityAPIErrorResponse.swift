//
//  UdacityAPIErrorResponse.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-06.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import Foundation

struct UdacityAPIErrorResponse: Codable, LocalizedError {
	let status: Int
	let error: String

	var errorDescription: String? {
		return error
	}
}
