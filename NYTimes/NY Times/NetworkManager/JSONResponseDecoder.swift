//
//  JSONResponseDecoder.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

struct JSONResponseDecoder {
	static func decode<T: Codable>(result: Data?) throws -> T? {
		guard let data = result else {
			return nil
		}
		return try JSONDecoder().decode(T?.self, from: data)
	}
}
