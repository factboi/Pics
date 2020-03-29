//
//  LoadingFooterView.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class LoadingFooterView: UICollectionReusableView {
	
	private let indicator = Indicator()

	private let label: UILabel = {
		let label = UILabel()
		label.text = "Loading more..."
		label.font = .boldSystemFont(ofSize: 17)
		label.adjustsFontSizeToFitWidth = true
		label.textAlignment = .center
		return label
	}()
	
	private func addIndicator() {
		addSubview(indicator)
		indicator.centerInSuperview()
		indicator.height(30)
		indicator.width(30)
	}
	
	private func addLabel() {
		addSubview(label)
		label.edgesToSuperview(excluding: .top, insets: .init(top: 0, left: 16, bottom: 8, right: 16))
		label.topToBottom(of: indicator)
	}
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		addIndicator()
		indicator.startIndicator()
		addLabel()
	}
}
