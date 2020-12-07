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
	var articleRepository: ArticleRepository?
	
	// MARK: - Lifecycle
	override func setUp() {
		
	}
	
	override func tearDown() {
		articleRepository = nil
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
	func testArticlesOK() {
		let articlesExpectation = expectation(description: "articlesSuccess")
		
		guard let requestURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json"),
			let data = getMockData() else {
				articlesExpectation.fulfill()
				return
		}
		
		let urlResponse = HTTPURLResponse(url: requestURL, statusCode: 200, httpVersion: nil, headerFields: nil)
		let mockSessionManager = MockSessionManager(data: data, urlResponse: urlResponse, error: nil)
		articleRepository = DefaultArticleRepository(mockSessionManager)
		
		articleRepository?.getAllArticles(period: .daily, completion: { response in
			if case .success = response {
				articlesExpectation.fulfill()
			}
		})
		
		waitForExpectations(timeout: 1)
	}
	
	func testArticlesNoResponseError() {
		let articlesExpectation = expectation(description: "articlesError")
		var articleError: Error?
		
		let mockSessionManager = MockSessionManager(data: nil, urlResponse: nil, error: nil)
		articleRepository = DefaultArticleRepository(mockSessionManager)
		
		articleRepository?.getAllArticles(period: .daily, completion: { response in
			if case .failure(let error) = response {
				articleError = error
				articlesExpectation.fulfill()
			}
		})
		
		waitForExpectations(timeout: 1) { _ in
			XCTAssertNotNil(articleError)
		}
	}
	
	func testArticles404Error() {
		let articlesExpectation = expectation(description: "articlesError")
		var articleError: Error?
		
		guard let requestURL = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json"),
			let data = getMockData() else {
				articlesExpectation.fulfill()
				return
		}
		
		let urlResponse = HTTPURLResponse(url: requestURL, statusCode: 404, httpVersion: nil, headerFields: nil)
		let mockSessionManager = MockSessionManager(data: data, urlResponse: urlResponse, error: nil)
		articleRepository = DefaultArticleRepository(mockSessionManager)
		
		articleRepository?.getAllArticles(period: .daily, completion: { response in
			if case .failure(let error) = response {
				articleError = error
				articlesExpectation.fulfill()
			}
		})
		
		waitForExpectations(timeout: 1) { _ in
			XCTAssertNotNil(articleError)
		}
	}
}
