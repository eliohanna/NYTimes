//
//  Extension+UITableViewCell.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import UIKit

protocol TableViewCellIdentifiable: UITableViewCell {
	static var identifier: String { get }
	static var xib: UINib { get }
}

extension UITableViewCell: TableViewCellIdentifiable {
	static var identifier: String {
		return String(describing: self)
	}
	
	static var xib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
}
