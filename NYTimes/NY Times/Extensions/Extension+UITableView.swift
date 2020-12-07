//
//  Extension+UITableView.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import UIKit

extension UITableView {
	func register(cellNib cell: TableViewCellIdentifiable.Type) {
		register(cell.xib, forCellReuseIdentifier: cell.identifier)
	}
}
