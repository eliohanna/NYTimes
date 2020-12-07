//
//  HomeViewModelTests.swift
//  NY TimesTests
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import XCTest
@testable import NY_Times

class HomeViewModelTests: XCTestCase {
	// MARK: - Properties
	var homeViewModel: HomeViewModel?
	
	// MARK: - Lifecycle
	override func setUp() {
		let input = HomeInputModel()
		
		guard let requestURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json"),
			let data = getMockData() else {
				return
		}
		let urlResponse = HTTPURLResponse(url: requestURL, statusCode: 200, httpVersion: nil, headerFields: nil)
		let mockSessionManager = MockSessionManager(data: data, urlResponse: urlResponse, error: nil)
		let articleRepository = DefaultArticleRepository(mockSessionManager)
		
		homeViewModel = HomeViewModel(input: input, delegate: nil, articleRepository: articleRepository)
	}
	
	override func tearDown() {
		homeViewModel = nil
	}
	
	// MARK: - Functions
	func getMockData() -> Data? {
		let testBundle = Bundle(for: type(of: self))
		guard let url = testBundle.url(forResource: "Mock", withExtension: "json"),
			let data: Data = NSData(contentsOf: url) as Data? else {
				XCTFail("Unable to read JSON file")
				return nil
		}
		
		return data
	}
	
	// MARK: - Tests
	func testFetchDataOK() {
		homeViewModel?.fetchData()
		XCTAssertEqual(homeViewModel?.numberOfRows(), 20)
	}
	
	func testSearchNoResultsOK() {
		homeViewModel?.fetchData()
		homeViewModel?.search(for: "this_should_not_return_any_result")
		XCTAssertEqual(homeViewModel?.numberOfRows(), 0)
	}
	
	func testSearchResetOK() {
		homeViewModel?.fetchData()
		homeViewModel?.search(for: "this_should_not_return_any_result")
		homeViewModel?.search(for: nil)
		XCTAssertEqual(homeViewModel?.numberOfRows(), 20)
	}
	
	func testSearchByTitleOK() {
		homeViewModel?.fetchData()
		homeViewModel?.search(for: "corona")
		XCTAssertEqual(homeViewModel?.numberOfRows(), 1)
		
		let result = homeViewModel?.model(at: IndexPath(row: 0, section: 0))
		XCTAssertNotNil(result?.title?.range(of: "corona", options: .caseInsensitive))
	}
	
	func testSearchByLineOK() {
		homeViewModel?.fetchData()
		homeViewModel?.search(for: "Maggie")
		XCTAssertEqual(homeViewModel?.numberOfRows(), 1)
		
		let result = homeViewModel?.model(at: IndexPath(row: 0, section: 0))
		XCTAssertNotNil(result?.subtitle?.range(of: "Maggie", options: .caseInsensitive))
	}
	
	func testSearchCaseInsensitiveOK() {
		homeViewModel?.fetchData()
		homeViewModel?.search(for: "maggie")
		XCTAssertEqual(homeViewModel?.numberOfRows(), 1)
		
		let result = homeViewModel?.model(at: IndexPath(row: 0, section: 0))
		XCTAssertNotNil(result?.subtitle?.range(of: "maggie", options: .caseInsensitive))
	}
}
