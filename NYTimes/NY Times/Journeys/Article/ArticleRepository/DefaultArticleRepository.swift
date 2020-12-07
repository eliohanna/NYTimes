//
//  DefaultArticleRepository.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

class DefaultArticleRepository: ArticleRepository {
	private let sessionManager: SessionManager
	
	init(_ sessionManager: SessionManager = DefaultSessionManager()) {
		self.sessionManager = sessionManager
	}
	
	func getAllArticles(period: Period, completion: @escaping ((Result<ArticleResponse?, Error>)) -> Void) {
		let params = Authentication(apiKey: "YLWkVbh2kdadTcDEvZROAW8TEs3aZnhO")
		
		guard let url = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/viewed/\(period.rawValue).json")
			else {
				completion(.failure(NetworkResponseError.badRequest))
				return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		try? URLParameterEncoder.encode(urlRequest: &request, parameters: params)
		
		sessionManager.request(request, completion: { result in
			switch result {
			case .success((let data, _)):
				let decoded: ArticleResponse? = try? JSONResponseDecoder.decode(result: data)
				completion(.success(decoded))
			case .failure(let error):
				completion(.failure(error))
			}
		})
	}
}
