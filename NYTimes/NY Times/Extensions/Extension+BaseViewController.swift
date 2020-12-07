//
//  Extension+BaseViewController.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import UIKit

protocol ViewControllerInstantiable: BaseViewController {
	static var storyboardIdentity: String { get }
}

protocol ViewControllerAlertPresentable: BaseViewController {
	func presentAlert(title: String?, description: String?)
}

extension BaseViewController: ViewControllerInstantiable {
	static var storyboardIdentity: String {
		return String(describing: self)
	}
	
	static func create(storyboardID: String, input: BaseInputModel) -> Self {
		let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
		return storyboard.instantiateViewController(identifier: storyboardIdentity,
													creator: { coder in
														return self.init(coder: coder, input: input)
		})
	}
}

extension BaseViewController: ViewControllerAlertPresentable {
	func presentAlert(title: String?, description: String?) {
		let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
		alertController.addAction(.init(title: "Ok", style: .cancel))
		present(alertController, animated: true)
	}
}
