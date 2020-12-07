//
//  ArticleMedia.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

struct ArticleMedia: Codable {
	var caption: String?
	var mediaMetadata: [ArticleMediaMetadata]?
	
	enum CodingKeys: String, CodingKey {
		case caption
		case mediaMetadata = "media-metadata"
	}
}

extension ArticleMedia {
	var thumbnail: ArticleMediaMetadata? {
		return mediaMetadata?.first(where: { $0.format == .thumbnail }) ?? mediaMetadata?.first
	}
	
	var medium210: ArticleMediaMetadata? {
		return mediaMetadata?.first(where: { $0.format == .medium210 }) ?? thumbnail
	}
	
	var medium440: ArticleMediaMetadata? {
		return mediaMetadata?.first(where: { $0.format == .medium440 }) ?? medium210
	}
}
