//
//  HomeViewModel.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import Foundation

class HomeViewModel {
	
	// MARK: - Properties
	private let input: HomeInputModel?
	private weak var delegate: HomeDelegate?
	private var dataSource: [Article] = [] {
		didSet {
			displayDataSource = dataSource
		}
	}
	private var displayDataSource: [Article] = []
	private var period: Period
	private let articleRepository: ArticleRepository
	
	// MARK: - Init
	init(input: BaseInputModel,
		 delegate: HomeDelegate?,
		 articleRepository: ArticleRepository = DefaultArticleRepository()) {
		self.input = input as? HomeInputModel
		self.delegate = delegate
		self.period = .daily
		self.articleRepository = articleRepository
		
		fetchData()
	}
	
	//MARK: - Private functions
	private func mapToUIModel(_ model: Article) -> HomeTableViewCell.UIModel {
		return .init(imageURL: model.media?.first?.thumbnail?.url,
					 title: model.title,
					 subtitle: model.byline,
					 date: model.publishDate)
	}
	
	private func getDate(from dateString: String?) -> Date? {
		guard let dateString = dateString else { return nil }
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd"
		return dateFormatter.date(from: dateString)
	}
	
	private func sortResults(_ results: [Article]?) -> [Article] {
		guard let results = results else { return [] }
		return results.sorted(by: {
			guard let date1 = getDate(from: $0.publishDate),
				let date2 = getDate(from: $1.publishDate) else { return false }
			return date1 > date2
		})
	}
	
	//MARK: - Public functions
	func fetchData() {
		delegate?.setLoading(isActive: true)
		articleRepository.getAllArticles(period: period, completion: { [weak self] response in
			self?.delegate?.setLoading(isActive: false)
			switch response {
			case .success(let result):
				let sortedResults = self?.sortResults(result?.results) ?? []
				self?.dataSource = sortedResults
				self?.delegate?.reloadData()
			case .failure(let error):
				self?.delegate?.showAlert(title: nil, description: error.localizedDescription)
			}
		})
	}
	
	func changePeriod(to newPeriod: Period) {
		guard newPeriod != period else { return }
		self.period = newPeriod
		fetchData()
	}
	
	func numberOfRows() -> Int {
		return displayDataSource.count
	}
	
	func model(at indexPath: IndexPath) -> HomeTableViewCell.UIModel? {
		guard indexPath.row < displayDataSource.count else { return nil }
		return mapToUIModel(displayDataSource[indexPath.row])
	}
	
	func didPressItem(at indexPath: IndexPath) {
		guard indexPath.row < displayDataSource.count else { return }
		let selectedArticle = displayDataSource[indexPath.row]
		let inputModel = DetailsInputModel(selectedArticle: selectedArticle)
		delegate?.navigateToDetails(with: inputModel)
	}
	
	func search(for text: String?) {
		if let text = text, !text.isEmpty {
			displayDataSource = dataSource.filter({
				return $0.title?.range(of: text, options: .caseInsensitive) != nil ||
					$0.byline?.range(of: text, options: .caseInsensitive) != nil
			})
		} else {
			displayDataSource = dataSource
		}
		
		delegate?.reloadData()
	}
}
