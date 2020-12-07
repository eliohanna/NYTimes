//
//  Article.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

struct Article: Codable {
	var title: String?
	var byline: String?
	var abstract: String?
	var publishDate: String?
	var source: String?
	var media: [ArticleMedia]?
	
	enum CodingKeys: String, CodingKey {
		case title
		case byline
		case abstract
		case publishDate = "published_date"
		case source
		case media
	}
}
