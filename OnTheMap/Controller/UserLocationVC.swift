//
//  UserLocationVC.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-07.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit
import MapKit


class UserLocationVC: UIViewController, MKMapViewDelegate {

	@IBOutlet weak var userUrlTextField: UITextField!

	@IBOutlet weak var mapView: MKMapView!
	
	var locationName: String!

	var coordinate: CLLocationCoordinate2D!


	override func viewDidLoad() {
		super.viewDidLoad()
		// Set the delegate into the map object
		mapView.delegate = self

		// Add user pin
		addUserPin(withCoordinates: coordinate)
	}

	@IBAction func confirm(_ sender: Any) {
		// Get the user information
		UdacityClient.getUserData { (userInfo, error) in
			guard let userUrl = self.userUrlTextField.text else { return }

			if let userInfo = userInfo {
				self.postPin(userUrl: userUrl, userName: userInfo.user.userName, lastName: userInfo.user.lastName)

			} else {
				// Post the pin here, we get an error because apparently there's an error getting the user information on the Udacity endpoint
				self.postPin(userUrl: userUrl, userName: "", lastName: "")
			}
		}
	}

	private func postPin(userUrl: String, userName: String, lastName: String) {
		// Since the user information can't be retrieved, simulate a name
		UdacityClient.postPin(user: PostUser(uniqueKey: UdacityClient.Auth.accountKey!, firstName: "Bob", lastName: "Marley", mapString: locationName, mediaURL: userUrl, latitude: coordinate.latitude, longitude: coordinate.latitude)) { (success, error) in
			if success {
				// Return to the root view controller
				self.navigationController!.popToRootViewController(animated: true)

			} else {
				// Show the user a proper error message
				self.showError(errorMessage: error!.localizedDescription)
			}
		}
	}

	private func showError(errorMessage: String) {
		let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

		show(alertController, sender: nil)
	}

	private func addUserPin(withCoordinates coordinates: CLLocationCoordinate2D) {
		// Set the point annotation with the proper coordinates and location name
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		annotation.title = locationName

		// We want to animate and set the pin into the center of the view with an animation
		let mapRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

		DispatchQueue.main.async {
			self.mapView.addAnnotation(annotation)
			self.mapView.setRegion(mapRegion, animated: true)
		}
	}
}
