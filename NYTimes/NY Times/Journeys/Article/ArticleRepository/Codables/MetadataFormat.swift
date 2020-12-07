//
//  MetadataFormat.swift
//  NY Times
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

enum MetadataFormat: String, Codable {
	case thumbnail = "Standard Thumbnail"
	case medium210 = "mediumThreeByTwo210"
	case medium440 = "mediumThreeByTwo440"
}
