//
//  HomeTableViewCell.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import UIKit

extension HomeTableViewCell {
	struct UIModel {
		var imageURL: URL?
		var title: String?
		var subtitle: String?
		var date: String?
	}
}

class HomeTableViewCell: UITableViewCell {
	@IBOutlet weak var newsImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
		setupViews()
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		newsImageView.image = nil
		titleLabel.text = ""
		subtitleLabel.text = ""
		dateLabel.text = ""
	}
	
	private func setupViews() {
		newsImageView.makeCircular()
		newsImageView.backgroundColor = .darkGray
		
		titleLabel.font = .preferredFont(forTextStyle: .headline)
		titleLabel.textColor = .black
		
		subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
		subtitleLabel.textColor = .gray
		
		dateLabel.font = .preferredFont(forTextStyle: .caption1)
		dateLabel.textColor = .gray
	}
	
	private func requestImage(for imageURL: URL?) {
		guard let imageURL = imageURL else { return }
		
		activityIndicator.startAnimating()
		
		let request = URLRequest(url: imageURL)
		ImageLoaderManager.shared.request(request, completion: { [weak self] result in
			DispatchQueue.main.async(execute: {
				self?.handleImage(with: result)
			})
		})
	}
	
	private func handleImage(with result: Result<Data, Error>) {
		activityIndicator.stopAnimating()
		
		if case .success(value: let imageData) = result {
			newsImageView.image = UIImage(data: imageData)
		}
	}
	
	func fillValues(with model: UIModel) {
		requestImage(for: model.imageURL)
		titleLabel.text = model.title
		subtitleLabel.text = model.subtitle
		dateLabel.text = model.date
	}
}
