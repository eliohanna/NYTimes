//
//  Authentication.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

struct Authentication: Codable {
	var apiKey: String
	
	enum CodingKeys: String, CodingKey {
		case apiKey = "api-key"
	}
}
