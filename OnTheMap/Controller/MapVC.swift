//
//  MapVC.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-06.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

	@IBOutlet weak var mapView: MKMapView!

	override func viewDidLoad() {
		super.viewDidLoad()

		mapView.delegate = self

		getStudentPins()
	}


	private func getStudentPins() {
		UdacityClient.getAllStudentLocations(completion:
			{ (results, error) in
			if let results = results {
				StudentModel.students = results

				self.mapView.addAnnotations(self.getAnnotations())

			} else {
				// Show an error to the user
				self.showError(errorMessage: error!.localizedDescription)
			}
		})
	}


	private func getAnnotations() -> [MKPointAnnotation] {
		var locations = [MKPointAnnotation]()

		for studentLocation in StudentModel.students { // students are not nil by now
			locations.append(studentLocation.studentPin)
		}

		return locations
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let reuseId = "mapPin"

		var mapPin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

		if mapPin == nil {
			mapPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			mapPin!.canShowCallout = true
			mapPin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
			mapPin!.pinTintColor = .blue
		} else {
			mapPin!.annotation = annotation
		}

		return mapPin
	}

	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

		if let mediaURL = URL(string: view.annotation!.subtitle!!) {
			// Open the LinkedIn profile of the student
			UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
		}
	}


	@IBAction func logoutTapped(_ sender: Any) {
		UdacityClient.logout { (success, error) in
			if success {
				// Dismiss the present view controller
				self.presentingViewController?.dismiss(animated: true, completion: nil)

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
	

}
