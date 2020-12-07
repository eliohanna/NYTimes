//
//  ArticleRepositoryTests.swift
//  NY TimesTests
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import XCTest
@testable import NY_Times

class ArticleRepositoryTests: XCTestCase {
	
	// MARK: - Properties
	var homeViewModel: HomeViewModel?
	var jsonData: Data?
	
	// MARK: - Lifecycle
	override func setUp() {
		let testBundle = Bundle(for: type(of: self))
		if let url = testBundle.url(forResource: "Mock", withExtension: "json"),
			let data: Data = NSData(contentsOf: url) as Data? {
			jsonData = data
		} else {
			XCTFail("Failed to setup")
		}
	}
	
	override func tearDown() {
		homeViewModel = nil
		jsonData = nil
	}
	
	// MARK: - Tests
	func testDecoding() {
		let decoded: ArticleResponse? = try? JSONResponseDecoder.decode(result: jsonData)
		XCTAssert(decoded != nil)
	}
}
