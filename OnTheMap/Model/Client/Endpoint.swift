//
//  Endpoint.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-04.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import Foundation

class Endpoint {
	
	enum Endpoints {
		static let base = "https://onthemap-api.udacity.com/v1"

		case createSessionId
		case logout
		case studentLocation
		case studentLocationLimit(limit: Int)
		case getUserInfo(userID: String)
		case postUserInfo

		var stringValue: String{
			switch self{
				case .createSessionId, .logout:
					return Endpoints.base + "/session"

				case .studentLocation:
					return Endpoints.base + "/StudentLocation"

				case .studentLocationLimit(let limit):
					return "\(Endpoint.Endpoints.base)/StudentLocation?limit=\(String(limit))&order=-updatedAt"

				case .getUserInfo(let userID): return "\(Endpoints.base)/users/\(userID)"

				case .postUserInfo: return "\(Endpoints.base)/StudentLocation"
			}
		}

		var url: URL{
			return URL(string: stringValue)!
		}
	}
}
