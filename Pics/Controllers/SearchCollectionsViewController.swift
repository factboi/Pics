//
//  SearchCollectionViewController.swift
//  Pics
//
//  Created by factboii on 01.04.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class SearchCollectionsViewController: UIViewController {
	
	private let searchTerm: String
	private let cellId = "cellId"
	private let footerId = "footerId"
	private var pageNumber = 0
	private var isPaginating = false
	private var unsplashClient = UnsplashClient()
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private var collections = Array<Collection>()
	
	private func setupViews() {
		view.addSubview(collectionView)
		collectionView.backgroundColor = .white
		collectionView.edgesToSuperview(usingSafeArea: true)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.minimumLineSpacing = 10
			layout.minimumInteritemSpacing = 10
			let width = (view.bounds.width - 30) / 2
			layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
			layout.itemSize = .init(width: width, height: width)
			layout.footerReferenceSize = .init(width: view.bounds.width, height: view.bounds.height * 0.1)
		}
	}
	
	private func fetchCollections(page: Int) {
		unsplashClient.getCollections(searchTerm: searchTerm, page: page, perPage: 10) { (res) in
			self.isPaginating = true
			switch res {
			case .success(let obj):
				self.collections += obj.results
				self.collections.removeDuplicates()
				self.collectionView.reloadData()
			case .error(let err):
				print(err)
			}
			self.isPaginating = false
		}
		pageNumber += 1
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setupViews()
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchCollections(page: pageNumber)
	}
	
	init(searchTerm: String) {
		self.searchTerm = searchTerm
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension SearchCollectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collections.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionCell
		cell.setWith(collections[indexPath.item])
		if indexPath.item == collections.count - 1 && !isPaginating {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.fetchCollections(page: self.pageNumber)
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let collectionDetailViewController = CollectionDetailViewController(collection: collections[indexPath.item])
		navigationController?.pushViewController(collectionDetailViewController, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
		return footer
	}
	
}
