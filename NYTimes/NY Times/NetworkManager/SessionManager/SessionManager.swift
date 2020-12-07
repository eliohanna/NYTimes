//
//  SessionManager.swift
//  NY Times
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

protocol SessionManager: class {
	var session: URLSession { get }
	
	func request(_ urlRequest: URLRequest, completion: @escaping (Result<(Data?, URLResponse?), Error>) -> Void)
}
