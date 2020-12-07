//
//  MockSessionManager.swift
//  NY TimesTests
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

@testable import NY_Times
import Foundation

class MockSessionManager: DefaultSessionManager {
	private let mockTask: MockTask
	
	init(data: Data?, urlResponse: URLResponse?, error: Error?) {
		mockTask = MockTask(data: data, urlResponse: urlResponse, error: error)
		super.init()
	}
	
	override func getDataTask(for urlRequest: URLRequest,
							  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
		-> URLSessionDataTask {
			mockTask.completion = completionHandler
			return mockTask
	}
}
