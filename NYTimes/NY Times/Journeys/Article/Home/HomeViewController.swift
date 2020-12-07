//
//  HomeViewController.swift
//  NY Times
//
//  Created by ElioHanna on 12/6/20.
//  Copyright © 2020 ElioHanna. All rights reserved.
//

import UIKit

protocol HomeDelegate: class {
	func setLoading(isActive: Bool)
	func reloadData()
	func showAlert(title: String?, description: String?)
	func navigateToDetails(with inputModel: DetailsInputModel)
}

class HomeViewController: BaseViewController {
	// MARK: - Properties
	@IBOutlet weak var tableView: UITableView!
	lazy var viewModel: HomeViewModel = {
		return HomeViewModel(input: input, delegate: self)
	}()
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
		return refreshControl
	}()
	lazy var searchButton: UIBarButtonItem = {
		return UIBarButtonItem(image: UIImage(named: "Home/search"),
							   style: .plain,
							   target: self, action: #selector(searchPressed))
	}()
	lazy var moreButton: UIBarButtonItem = {
		return UIBarButtonItem(image: UIImage(named: "Home/more"),
							   style: .plain,
							   target: self, action: #selector(morePressed))
	}()
	lazy var searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search news"
		definesPresentationContext = true
		return searchController
	}()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
	}
	
	private func setupViews() {
		tableView.register(cellNib: HomeTableViewCell.self)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.refreshControl = refreshControl
		
		navigationItem.rightBarButtonItems = [searchButton, moreButton]
	}
	
	// MARK: - Private functions
	@objc private func refreshControlTriggered() {
		viewModel.fetchData()
	}
	
	@objc private func searchPressed() {
		if navigationItem.searchController == nil {
			showSearchBar()
		} else {
			hideSearchBar()
		}
		
		navigationController?.view.setNeedsLayout()
		navigationController?.view.layoutIfNeeded()
	}
	
	@objc private func morePressed() {
		let alertController = UIAlertController(title: "Change period", message: nil, preferredStyle: .actionSheet)
		alertController.addAction(.init(title: "Daily", style: .default, handler: { [weak viewModel] _ in
			viewModel?.changePeriod(to: .daily)
		}))
		alertController.addAction(.init(title: "Weekly", style: .default, handler: { [weak viewModel] _ in
			viewModel?.changePeriod(to: .weekly)
		}))
		alertController.addAction(.init(title: "Monthly", style: .default, handler: { [weak viewModel] _ in
			viewModel?.changePeriod(to: .monthly)
		}))
		alertController.addAction(.init(title: "Cancel", style: .cancel))
		present(alertController, animated: true)
	}
	
	private func showSearchBar() {
		navigationItem.searchController = searchController
		DispatchQueue.main.async(execute: {
			self.searchController.searchBar.becomeFirstResponder()
		})
	}
	
	private func hideSearchBar() {
		navigationItem.searchController = nil
	}
}

// MARK: - Extensions
extension HomeViewController: UISearchBarDelegate {
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		hideSearchBar()
	}
}

extension HomeViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier)
			as? HomeTableViewCell else { fatalError("Couldn't dequeue cell") }
		
		if let model = viewModel.model(at: indexPath) {
			cell.fillValues(with: model)
		}
		
		return cell
	}
}

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		viewModel.didPressItem(at: indexPath)
	}
}

extension HomeViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text
		viewModel.search(for: text)
	}
}

extension HomeViewController: HomeDelegate {
	func setLoading(isActive: Bool) {
		DispatchQueue.main.async(execute: {
			if isActive {
				self.refreshControl.beginRefreshing()
				
				let yOffset = self.tableView.contentOffset.y - self.refreshControl.frame.size.height
				self.tableView.setContentOffset(CGPoint(x: 0, y: yOffset),
												animated: true)
			} else {
				self.refreshControl.endRefreshing()
			}
		})
	}
	
	func reloadData() {
		DispatchQueue.main.async(execute: { [weak tableView] in
			tableView?.reloadData()
		})
	}
	
	func showAlert(title: String?, description: String?) {
		DispatchQueue.main.async(execute: { [weak self] in
			self?.presentAlert(title: title, description: description)
		})
	}
	
	func navigateToDetails(with inputModel: DetailsInputModel) {
		let viewController = DetailsViewController.create(storyboardID: "Article", input: inputModel)
		navigationController?.pushViewController(viewController, animated: true)
	}
}
