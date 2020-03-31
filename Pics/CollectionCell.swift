//
//  CollectionCell.swift
//  Pics
//
//  Created by factboii on 31.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
	
	private let imageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.layer.masksToBounds = true
		iv.layer.cornerRadius = 12
		iv.alpha = 0
		return iv
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .boldSystemFont(ofSize: 20)
		label.adjustsFontSizeToFitWidth = true
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	private let usernameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		label.adjustsFontSizeToFitWidth = true
		label.textAlignment = .center
		label.textColor = .white
		return label
	}()
	
	func setWith(_ collection: Collection?) {
		guard let collection = collection else { return }
		imageView.sd_setImage(with: URL(string: collection.coverPhoto.urls.small)) { (_, _, _, _) in
			UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
				self.imageView.alpha = 1
			})
		}
		titleLabel.text = collection.title
		usernameLabel.text = "@\(collection.user.username)"
	}
	
	private func addImageView() {
		addSubview(imageView)
		imageView.edgesToSuperview()
	}
	
	private func addLabels() {
		let stack = UIStackView(arrangedSubviews: [titleLabel, usernameLabel])
		stack.axis = .vertical
		addSubview(stack)
		stack.edgesToSuperview(insets: .init(top: 16, left: 16, bottom: 16, right: 16))
	}
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		layer.cornerRadius = 12
		addImageView()
		addLabels()
	}
	
}
