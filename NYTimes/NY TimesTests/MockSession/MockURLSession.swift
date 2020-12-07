//
//  MockURLSession.swift
//  NY TimesTests
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {
	private let mockTask: MockTask
	
	init(data: Data?, urlResponse: URLResponse?, error: Error) {
		mockTask = MockTask(data: data, urlResponse: urlResponse, error: error)
	}
	
	override func dataTask(with url: URL,
						   completionHandler completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		mockTask.completion = completion
		return mockTask
	}
}
