//
//  ImageLoaderManager.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

class ImageLoaderManager {
	// MARK: - Properties
	private let cache: URLCache = .shared
	private let session: URLSession = .shared
	private var tasks: [URLSessionTask] = []
	private let sessionManager = DefaultSessionManager()
	
	static var shared = ImageLoaderManager()
	
	// MARK: - Init
	private init() {
		// Private init. Please use the shared instance
	}
	
	public func request(_ urlRequest: URLRequest, forceRefresh: Bool = false, completion: @escaping (Result<Data, Error>) -> Void) {
		if forceRefresh {
			cache.removeCachedResponse(for: urlRequest)
		}
		
		if let data = cache.cachedResponse(for: urlRequest)?.data {
			completion(.success(data))
			return
		}
		
		sessionManager.request(urlRequest, completion: { result in
			switch result {
			case .success((let data, let response)):
				guard let data = data, let response = response else {
					completion(.failure(NetworkResponseError.noData))
					return
				}
				let cachedData = CachedURLResponse(response: response, data: data)
				self.cache.storeCachedResponse(cachedData, for: urlRequest)
				completion(.success(data))
			case .failure(let error):
				completion(.failure(error))
			}
		})
	}
}
