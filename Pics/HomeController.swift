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

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

class HomeController: UIViewController {
	
	private let cellId = "cellId"
	private let footerId = "footerID"
	private var pageNumber = 0
	private var isPaginating = false
	private var photos = Array<Photo>() {
		didSet {
			photos.removeDuplicates()
		}
	}
	private let unsplashClient = UnsplashClient()
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private func setupViews() {
		view.addSubview(collectionView)
		collectionView.edgesToSuperview()
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = .white
		collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setupViews()
		
	}
	
	private func fetchPhotos(pageNumber: Int) {
		unsplashClient.fetch(.photos(id: UnsplashClient.apiKey, page: pageNumber, perPage: 5, orderBy: .latest)) { (result) in
			self.isPaginating = true
			switch result {
			case .success(let photos):
				self.photos += photos
				self.collectionView.reloadData()
			case .error(let error):
				print("\(error)")
			}
			self.isPaginating = false
		}
	
		self.pageNumber += 1
		print("fetching with page number \(self.pageNumber)")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchPhotos(pageNumber: pageNumber)
	}

}

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
		cell.set(with: photos[indexPath.item])
		
		if indexPath.item == photos.count - 1 && !isPaginating {
			self.fetchPhotos(pageNumber: pageNumber)
		}
		
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
