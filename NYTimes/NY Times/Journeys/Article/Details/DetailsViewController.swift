//
//  DetailsViewController.swift
//  NY Times
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import UIKit

protocol DetailsDelegate: class {
	func fillData(with model: DetailsViewController.UIModel)
}

extension DetailsViewController {
	struct UIModel {
		var imageURL: URL?
		var title: String?
		var subtitle: String?
		var date: String?
	}
}

class DetailsViewController: BaseViewController {
	// MARK: - Properties
	@IBOutlet weak var newsImageView: UIImageView!
	@IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	lazy var viewModel: DetailsViewModel = {
		return DetailsViewModel(input: input, delegate: self)
	}()
	
	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
		viewModel.loadData()
    }
	
	private func setupViews() {
		newsImageView.backgroundColor = .darkGray
		
		titleLabel.font = .preferredFont(forTextStyle: .headline)
		titleLabel.textColor = .black
		
		subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
		subtitleLabel.textColor = .gray
		
		dateLabel.font = .preferredFont(forTextStyle: .caption1)
		dateLabel.textColor = .gray
	}
	
	// MARK: - Private functions
	private func requestImage(for imageURL: URL?) {
		guard let imageURL = imageURL else { return }
		
		let request = URLRequest(url: imageURL)
		ImageLoaderManager.shared.request(request, completion: { [weak self] result in
			DispatchQueue.main.async(execute: {
				self?.handleImage(with: result)
			})
		})
	}
	
	private func handleImage(with result: Result<Data, Error>) {
		if case .success(value: let imageData) = result {
			guard let image = UIImage(data: imageData) else { return }
			
			let imageViewHeight = (image.size.height/image.size.width) * newsImageView.frame.width
			imageViewHeightConstraint.constant = imageViewHeight
			
			newsImageView.image = image
		}
	}
}

// MARK: - Extensions
extension DetailsViewController: DetailsDelegate {
	func fillData(with model: UIModel) {
		requestImage(for: model.imageURL)
		titleLabel.text = model.title
		subtitleLabel.text = model.subtitle
		dateLabel.text = model.date
	}
}
