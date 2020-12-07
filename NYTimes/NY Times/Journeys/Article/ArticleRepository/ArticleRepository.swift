//
//  ArticleRepository.swift
//  NY Times
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

protocol ArticleRepository: class {
	func getAllArticles(period: Period, completion: @escaping ((Result<ArticleResponse?, Error>)) -> Void)
}
