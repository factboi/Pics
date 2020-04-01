//
//  PhotosViewController.swift
//  Pics
//
//  Created by factboii on 01.04.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class SearchPhotosViewController: UIViewController {
	
	private let searchTerm: String
	private let cellId = "cellId"
	private let footerId = "footerId"
	private var pageNumber = 0
	private var isPaginating = false
	private var unsplashClient = UnsplashClient()
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private var photos = Array<Photo>()
	
	private func setupViews() {
		view.addSubview(collectionView)
		collectionView.backgroundColor = .white
		collectionView.edgesToSuperview(usingSafeArea: true)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setupViews()
	}
	
	private func fetchPhotos(page: Int) {
		unsplashClient.getPhotos(searchTerm: searchTerm, page: page, perPage: 10, order: .relevant) { (res) in
			self.isPaginating = true
			switch res {
			case .success(let obj):
				self.photos += obj.results
				self.photos.removeDuplicates()
				self.collectionView.reloadData()
			case .error(let err):
				print(err)
			}
			self.isPaginating = false
		}
		pageNumber += 1
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchPhotos(page: pageNumber)
	}
	
	
	init(searchTerm: String) {
		self.searchTerm = searchTerm
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension SearchPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
		return footer
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
		cell.set(with: photos[indexPath.item])
		if indexPath.item == photos.count - 1 && !isPaginating {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.fetchPhotos(page: self.pageNumber)
			}
		}
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return .init(width: view.bounds.width, height: view.bounds.height * 0.1)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let photo = photos[indexPath.item]
		let width = view.bounds.width
		let scale = CGFloat(photo.width) / CGFloat(photo.height)
		let height = width / scale
		return .init(width: width, height: height)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 2
	}
}
