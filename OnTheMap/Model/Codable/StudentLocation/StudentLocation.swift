//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-07.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation: Codable {
	let createdAt: String
	let firstName: String
	let lastName: String
	let latitude: Double
	let longitude: Double
	let mapString: String
	let mediaURL: String
	let objectId: String
	let uniqueKey: String
	let updatedAt: String

	var studentPin: MKPointAnnotation {
		let mapAnnotation = MKPointAnnotation()
		mapAnnotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
		mapAnnotation.title = "\(firstName) \(lastName)"
		mapAnnotation.subtitle = "\(mediaURL)"
		return mapAnnotation
	}
}
