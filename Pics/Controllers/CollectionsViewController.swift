//
//  CollectionsViewController.swift
//  Pics
//
//  Created by factboii on 31.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {
	
	private let unsplashClient = UnsplashClient()
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private let cellId = "cellId"
	private let footerId = "footerId"
	private var collections = Array<Collection>()
	private var pageNumber = 0
	private var isPaginating = false
	
	private func setupViews() {
		navigationItem.title = "Explore 🌅"
		view.addSubview(collectionView)
		collectionView.edgesToSuperview(usingSafeArea: true)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.backgroundColor = .white
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
	
	
	private func getCollections(pageNumber: Int) {
		unsplashClient.getCollections(page: pageNumber, perPage: 10) { (result) in
			self.isPaginating = true
			switch result {
			case .success(let collections):
				self.collections += collections
				self.collections.removeDuplicates()
				self.collectionView.reloadData()
			case .error(let error):
				print(error)
			}
			self.isPaginating = false
		}
		self.pageNumber += 1
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setupViews()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getCollections(pageNumber: pageNumber)
	}
}

extension CollectionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collections.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionCell
		cell.setWith(collections[indexPath.item])
		
		if indexPath.item == collections.count - 1 && !isPaginating {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.getCollections(pageNumber: self.pageNumber)
			}
		}
		
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let detail = CollectionDetailViewController(collection: collections[indexPath.item])
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		navigationController?.pushViewController(detail, animated: true)
	}
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
		return footer
	}
}
