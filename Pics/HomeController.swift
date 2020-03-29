//
//  ViewController.swift
//  Pics
//
//  Created by factboii on 26.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit
import TinyConstraints
import SDWebImage

class HomeController: UIViewController {
	
	private let cellId = "cellId"
	private let footerId = "footerID"
	
	private var photos: [Photo] = []
	private let unsplashClient = UnsplashClient()
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private let indicator = Indicator()
	private func setupViews() {
		view.addSubview(collectionView)
		collectionView.edgesToSuperview()
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = .white
		collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
		collectionView.addSubview(indicator)
		indicator.centerInSuperview(usingSafeArea: true)
		indicator.height(30)
		indicator.width(30)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setupViews()
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		indicator.startIndicator()
		unsplashClient.fetch(.photos(id: UnsplashClient.apiKey, page: 15, perPage: 5, orderBy: .latest)) { (result) in
			switch result {
			case .success(let photos):
				self.photos = photos
				self.indicator.stopIndicator()
				self.collectionView.reloadSections(IndexSet(integer: 0))
			case .error(let error):
				print("\(error)")
			}
		}
	}

}

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
		cell.set(with: photos[indexPath.item])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
		return footer
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
