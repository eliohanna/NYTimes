//
//  NetworkResponseError.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

enum NetworkRequestError : String, Error {
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

enum NetworkResponseError: String, Error {
	case noData = "Response returned with no data to decode."
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case failed = "Network request failed."
    case unableToDecode = "We could not decode the response."
}
