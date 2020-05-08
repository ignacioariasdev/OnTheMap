//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Marlhex on 2020-05-04.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import Foundation

class UdacityClient {

	struct Auth {
		static var accountKey: String?
		static var sessionID: String?
	}


	// MARK: - GetUserData
	class func getUserData(completion: @escaping (UserResponse?, Error?) -> Void) {
		taskForGETRequest(url: Endpoint.Endpoints.getUserInfo(userID: Auth.accountKey!).url, responseType: UserResponse.self) { (response, error) in
			if let response = response {
				completion(response, nil)

			} else {
				completion(nil, error)
			}
		}
	}

	class func postPin(user: PostUser, completion: @escaping (Bool, Error?) -> Void) {
		let headers = ["Content-Type" : "application/json"]

		taskForPOSTRequest(shouldSanitize: false, body: user, url: Endpoint.Endpoints.postUserInfo.url, values: headers, responseType: PostUserLocationResponse.self) { (response, error) in
			if response != nil {
				completion(true, nil)

			} else {
				completion(false, error)
			}
		}
	}




	// MARK: - StudentLocations

	class func taskForGETRequest<T: Decodable>(url: URL, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) -> URLSessionTask {
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data else {
				DispatchQueue.main.async {
					completion(nil, error)
				}

				return
			}

			let decoder = JSONDecoder()
			do {
				let responseObject = try decoder.decode(T.self, from: data)

				DispatchQueue.main.async {
					completion(responseObject, nil)
				}

			} catch {
				do {
					let errorResponse = try decoder.decode(UdacityAPIErrorResponse.self, from: data)

					DispatchQueue.main.async {
						completion(nil, errorResponse)
					}

				} catch {
					DispatchQueue.main.async {
						completion(nil, error)
					}
				}
			}
		}

		task.resume()

		return task
	}



	class func getAllStudentLocations(completion: @escaping ([StudentLocation]?, Error?) -> Void) {
		taskForGETRequest(url: Endpoint.Endpoints.studentLocation.url, responseType: StudentLocationResults.self) { (response, error) in
			if let response = response {
				completion(response.results, nil)

			} else {
				completion(nil, error)
			}
		}
	}

	class func getAllStudentLocationsWithLimit(limit: Int, completion: @escaping ([StudentLocation]?, Error?) -> Void) {

		print("The url is: \(Endpoint.Endpoints.studentLocationLimit(limit: limit).url)")
		taskForGETRequest(url: Endpoint.Endpoints.studentLocationLimit(limit: limit).url, responseType: StudentLocationResults.self) { (response, error) in
			if let response = response {
				completion(response.results, nil)
			} else {
				completion(nil, error)
			}
		}
	}


	// MARK: - Create logout
	class func logout(completion: @escaping (Bool, Error?) -> Void) {

		var request = URLRequest(url: Endpoint.Endpoints.logout.url)
		request.httpMethod = "DELETE"

		var xsrfCookie: HTTPCookie? = nil
		let sharedCookieStorage = HTTPCookieStorage.shared

		for cookie in sharedCookieStorage.cookies! {
			if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie}
		}

		if let xsrfCookie = xsrfCookie {
			request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
		}

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error == nil {
				DispatchQueue.main.async {
					completion(true, nil)
				}

			} else {
				DispatchQueue.main.async {
					completion(false, error)
				}
			}
		}
		task.resume()
	}

	// MARK: - Create session
	class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(shouldSanitize: Bool, body: RequestType, url: URL, values: [String: String], responseType: ResponseType.Type,completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
		var request = URLRequest(url: url)
		request.httpBody = try! JSONEncoder().encode(body)

		for value in values {
			request.addValue(value.value, forHTTPHeaderField: value.key)
		}

		request.httpMethod = "POST"

		let session = URLSession.shared
		let task = session.dataTask(with: request) {
			data, response, error in
			if let data = data {
				let jsonDecoder = JSONDecoder()

				do {
					let responseObject = shouldSanitize ? try jsonDecoder.decode(ResponseType.self, from: sanitizeData(data: data)) : try jsonDecoder.decode(ResponseType.self, from: data)
					DispatchQueue.main.async {
						completion(responseObject, nil)
					}

				} catch {
					do {
						let errorResponse = shouldSanitize ? try jsonDecoder.decode(UdacityAPIErrorResponse.self, from: sanitizeData(data: data)) : try jsonDecoder.decode(UdacityAPIErrorResponse.self, from: data)

						DispatchQueue.main.async {
							completion(nil, errorResponse)
						}

					} catch {
						DispatchQueue.main.async {
							completion(nil, error)
						}
					}
				}

			} else {
				DispatchQueue.main.async {
					completion(nil, error)
				}
			}
		}

		task.resume()

		return task
	}



	// MARK: - together
	class func loginUdacityAPI(userTypedEmail: String, userTypedPassword: String, completion: @escaping (Bool, Error?) -> Void) {

		let body = SessionRequest(user: User(username: userTypedEmail, password: userTypedPassword))


		taskForPOSTRequest(shouldSanitize: true, body: body, url: Endpoint.Endpoints.createSessionId.url, values: ["Accept": "application/json", "Content-Type": "application/json"], responseType: PostSession.self) { (response, error) in
			if let response = response {
				Auth.sessionID = response.session.id
				Auth.accountKey = response.account.key

				completion(true, nil)

			} else {
				completion(false, error)
			}
		}
	}

	// MARK: - trim first 5 characters
	class func sanitizeData(data: Data) -> Data{
		return data.subdata(in: 5..<data.count)
	}
}
