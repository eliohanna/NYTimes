//
//  DefaultSessionManager.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

class DefaultSessionManager: SessionManager {
	// MARK: - Properties
	internal let session: URLSession
	
	// MARK: - Init
	public init(session: URLSession = .shared) {
		self.session = session
	}
	
	func getDataTask(for urlRequest: URLRequest,
					 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		return session.dataTask(with: urlRequest, completionHandler: completionHandler)
	}
	
	func request(_ urlRequest: URLRequest, completion: @escaping (Result<(Data?, URLResponse?), Error>) -> Void) {
		getDataTask(for: urlRequest, completionHandler: { (data, response, error) in
			let response = self.process(response: response, for: data)
			switch response {
			case .success(let data):
				completion(.success(data))
			case.failure(let error):
				completion(.failure(error))
			}
		}).resume()
	}
	
	private func process(response: URLResponse?,
						 for data: Data?) -> Result<(Data?, URLResponse?), NetworkResponseError> {
		guard let response = response as? HTTPURLResponse else { return .failure(.failed) }
		
		switch response.statusCode {
		case 200...299:
			return .success((data, response))
		case 401...500:
			return .failure(.authenticationError)
		case 501...599:
			return .failure(.badRequest)
		default:
			return .failure(.failed)
		}
	}
}
