//
//  HomeCell.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCell: UICollectionViewCell {
	
	private let imageView: UIImageView = {
		let iv = UIImageView()
		iv.alpha = 0
		iv.contentMode = .scaleAspectFit
		return iv
	}()
	
	private let label: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .boldSystemFont(ofSize: 20)
		label.adjustsFontSizeToFitWidth = true
		return label
	}()
	
	public func set(with photo: Photo?) {
		guard let pic = photo else {return}
		imageView.sd_setImage(with: URL(string: pic.urls.regular)) { (_, _, _, _) in
			UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
				self.imageView.alpha = 1
			})
		}
		label.text = photo?.user.username
	}
	
	private func addImageView() {
		addSubview(imageView)
		imageView.edgesToSuperview()
	}
	
	private func addLabel() {
		addSubview(label)
		label.edgesToSuperview(excluding: .top, insets: .init(top: 0, left: 16, bottom: 16, right: 16))
	}
	
	override func didMoveToSuperview() {
		addImageView()
		addLabel()
	}
}
