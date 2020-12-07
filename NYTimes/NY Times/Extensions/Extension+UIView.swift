//
//  Extension+UIView.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import UIKit

extension UIView {
	func addCornerRadius(_ radius: CGFloat = 3) {
		layer.cornerRadius = radius
		layer.masksToBounds = true
	}
	
	func makeCircular() {
		addCornerRadius(frame.height / 2)
	}
}
