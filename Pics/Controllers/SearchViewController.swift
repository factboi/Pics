//
//  SearchViewController.swift
//  Pics
//
//  Created by factboii on 31.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
	
	@IBOutlet var collectionsSearchLabel: UILabel!
	@IBOutlet var photosSearchLabel: UILabel!
	private let searchController = UISearchController(searchResultsController: nil)
	
	private func setupViews() {
		navigationItem.searchController = searchController
		searchController.obscuresBackgroundDuringPresentation = false
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.delegate = self
		searchController.searchBar.searchBarStyle = .minimal
		searchController.searchBar.autocorrectionType = .no
		searchController.searchBar.autocapitalizationType = .none
		searchController.searchBar.returnKeyType = .default
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setupViews()
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.setEmptyView()
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let searchTerm = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
		if searchTerm.isEmpty {
			print("nope")
		} else {
			switch indexPath.item {
			case 0:
				let searchPhotosViewController = SearchPhotosViewController(searchTerm: searchTerm)
				navigationController?.pushViewController(searchPhotosViewController, animated: true)
			case 1:
				let searchCollectionsViewController = SearchCollectionsViewController(searchTerm: searchTerm)
				navigationController?.pushViewController(searchCollectionsViewController, animated: true)
			default: return
			}
		}
	}
}

extension SearchViewController: UISearchBarDelegate, UITextFieldDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			collectionsSearchLabel.text = ""
			photosSearchLabel.text = ""
			tableView.setEmptyView()
		} else {
			tableView.restore()
			collectionsSearchLabel.text = "Collections With: '\(searchText)'"
			photosSearchLabel.text = "Photos With: '\(searchText)'"
			print(searchText)
		}
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		guard let searchText = searchBar.text else { return }
		if searchText.isEmpty {
			tableView.setEmptyView()
		} else {
			tableView.restore()
			collectionsSearchLabel.text = "Collections With: '\(searchText)'"
			photosSearchLabel.text = "Photos With: '\(searchText)'"
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = ""
		collectionsSearchLabel.text = ""
		photosSearchLabel.text = ""
		tableView.setEmptyView()
	}
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		collectionsSearchLabel.text = ""
		photosSearchLabel.text = ""
		tableView.setEmptyView()
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		view.endEditing(false)
		return false
	}
}





class EmptyView: UIView {
	
	// MARK: Private
	private let emojiLabel = UILabel()
	private let messageLabel = UILabel()
	private let shadow = CAShapeLayer()
	
	// MARK: Override
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		emojiLabel.textAlignment = .center
		emojiLabel.backgroundColor = .clear
		emojiLabel.font = .systemFont(ofSize: 60)
		addSubview(emojiLabel)
		emojiLabel.centerInSuperview(offset: .init(x: 0, y: -35))
		
		
		shadow.fillColor = UIColor(white: 0, alpha: 0.05).cgColor
		layer.addSublayer(shadow)
		
		messageLabel.textAlignment = .center
		messageLabel.backgroundColor = .clear
		messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
		messageLabel.textColor = .lightGray
		
		addSubview(messageLabel)
		messageLabel.centerX(to: emojiLabel)
		messageLabel.topToBottom(of: emojiLabel, offset: 35)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let width: CGFloat = 30
		let height: CGFloat = 12
		let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
		shadow.path = UIBezierPath(ovalIn: rect).cgPath
		
		let bounds = self.bounds
		shadow.bounds = rect
		shadow.position = CGPoint(
			x: bounds.width/2,
			y: bounds.height/2 + 15
		)
	}
	
	override func didMoveToWindow() {
		super.didMoveToWindow()
	}
	
	func configure(emoji: String, message: String) {
		emojiLabel.text = emoji
		messageLabel.text = message
	}
}

extension UITableView {
	func setEmptyView() {
		let emptyView = EmptyView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
		emptyView.configure(emoji: "🏞", message: "Search Unsplash")
		self.backgroundView = emptyView
		self.separatorStyle = .none
	}
	func restore() {
		self.backgroundView = nil
		self.separatorStyle = .singleLine
	}
}
