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
	private var pageNumber = 0
	private var isPaginating = false
	private var photos = Array<Photo>()
	private let unsplashClient = UnsplashClient()
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	
	private func setupViews() {
		view.addSubview(collectionView)
		collectionView.edgesToSuperview(usingSafeArea: true)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = .white
		collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
		
		let changeOrderButton = UIBarButtonItem.init(image: UIImage(systemName: "flame"), style: .plain, target: self, action: #selector(changeOrderButtonClicked(_:)))
		changeOrderButton.tintColor = .black
		navigationItem.rightBarButtonItem = changeOrderButton
	}
	
	private var order: Order = .latest {
		didSet {
			switch order {
			case .latest:
				navigationItem.rightBarButtonItem?.image = UIImage(systemName: "flame")
			case .popular:
				navigationItem.rightBarButtonItem?.image = UIImage(systemName: "arrow.up.right")
			default:
				return
			}
		}
	}
	
	private var isOrderChanged = false {
		didSet {
			order = isOrderChanged ? .popular : .latest			
		}
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		setupViews()
	}
	
	@objc private func changeOrderButtonClicked(_ sender: UIBarButtonItem) {
		isOrderChanged = !isOrderChanged
		pageNumber = 0
		photos.removeAll()
		fetchPhotos(pageNumber: pageNumber, order: order)
		collectionView.reloadSections(.init(integer: .zero))
		collectionView.setContentOffset(.zero, animated: true)
	}
	
	private func fetchPhotos(pageNumber: Int, order: Order) {
		unsplashClient.getPhotos(page: pageNumber, perPage: 10, order: order) { (res) in
			self.isPaginating = true
			switch res {
			case .success(let photos):
				self.photos += photos
				self.photos.removeDuplicates()
				self.collectionView.reloadData()
			case .error(let err):
				print(err)
			}
			self.isPaginating = false
		}
		self.pageNumber += 1
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchPhotos(pageNumber: pageNumber, order: order)
	}
}

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
		cell.set(with: photos[indexPath.item])
		
		if indexPath.item == photos.count - 1 && !isPaginating {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.fetchPhotos(pageNumber: self.pageNumber, order: self.order)
			}
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
