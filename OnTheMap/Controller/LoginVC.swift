//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-04.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

	@IBOutlet weak var userNameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadingIndicator.isHidden = true
	}

	@IBAction func submitLogin(_ sender: Any) {
		loadingIndicator.startAnimating()
		loadingIndicator.isHidden = false
		
		UdacityClient.loginUdacityAPI(userTypedEmail: userNameTextField.text ?? "", userTypedPassword: passwordTextField.text ?? "", completion: handleCreateSession(success:error:))
	}

	private func handleCreateSession(success: Bool, error: Error?) {

		loadingIndicator.stopAnimating()
		loadingIndicator.isHidden = true

		if success {
			performSegue(withIdentifier: "root", sender: nil)
		} else {
			// There was an error login in
			self.showError(errorMessage: error!.localizedDescription)
		}
	}

	private func showError(errorMessage: String) {

		//Box title
		let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)

		//Button title
		alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

		show(alertController, sender: nil)
	}
}
