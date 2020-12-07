//
//  BaseViewController.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
	// MARK: - Properties
	let input: BaseInputModel
	
	// MARK: - Init
	required init?(coder: NSCoder, input: BaseInputModel) {
		self.input = input
		super.init(coder: coder)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) shouldn't be called. Use init?(coder: NSCoder, input: BaseModelInput) instead.")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Use this to perform actions on all viewControllers that subclass BaseViewController
	}
}
