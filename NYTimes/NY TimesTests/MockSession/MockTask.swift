//
//  MockTask.swift
//  NY TimesTests
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

class MockTask: URLSessionDataTask {
	private let mockData: Data?
	private let mockResponse: URLResponse?
	private let mockError: Error?
	
	var completion: ((Data?, URLResponse?, Error?) -> Void)?
	init(data: Data?, urlResponse: URLResponse?, error: Error?) {
		self.mockData = data
		self.mockResponse = urlResponse
		self.mockError = error
	}
	
	override func resume() {
		completion?(mockData, mockResponse, mockError)
	}
}
