//
//  DetailsViewModel.swift
//  NY Times
//
//  Created by ElioHanna on 12/7/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

class DetailsViewModel {
	
	// MARK: - Properties
	private let input: DetailsInputModel
	weak var delegate: DetailsDelegate?
	
	// MARK: - Init
	init(input: BaseInputModel, delegate: DetailsDelegate?) {
		guard let input = input as? DetailsInputModel else { fatalError("Input should be of DetailsInputModel type") }
		self.input = input
		self.delegate = delegate
	}
	
	//MARK: - Private functions
	private func mapToUIModel(_ model: Article) -> DetailsViewController.UIModel {
		// We are taking the last mediaMetadata, since it has the highest quality
		return .init(imageURL: model.media?.first?.medium440?.url,
					 title: model.title,
					 subtitle: model.byline,
					 date: model.publishDate)
	}
	
	//MARK: - Public functions
	func loadData() {
		delegate?.fillData(with: mapToUIModel(input.selectedArticle))
	}
}
