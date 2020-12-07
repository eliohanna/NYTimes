//
//  URLParameterEncoder.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

struct URLParameterEncoder {
	static func encode<T: Codable>(urlRequest: inout URLRequest, parameters: T) throws {
		guard let url = urlRequest.url else { throw NetworkRequestError.missingURL }
		
		if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
			urlComponents.queryItems = getQueryItems(for: parameters)
			
			urlRequest.url = urlComponents.url
		}
		
		if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
			urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
		}
	}
	
	private static func getQueryItems<T: Codable>(for parameters: T) -> [URLQueryItem] {
		guard let data = try? JSONEncoder().encode(parameters) else { return [] }
		let jsonObject = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
			.flatMap { $0 as? [String: Any] } ?? [:]
		
		return jsonObject.map({ (key: String, value: Any) -> URLQueryItem in
			let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			return URLQueryItem(name: key, value: encodedValue)
		})
	}
}
