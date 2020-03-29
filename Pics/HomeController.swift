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
	private var photos: [Photo] = []
	private let unsplashClient = UnsplashClient()
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	
	private func setupViews() {
		view.addSubview(collectionView)
		collectionView.edgesToSuperview()
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = .white
		collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setupViews()
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		unsplashClient.fetch(.photos(id: UnsplashClient.apiKey, page: 0, perPage: 5, orderBy: .latest)) { (result) in
			switch result {
			case .success(let photos):
				self.photos = photos
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
