//
//  LoadingFooterView.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class LoadingFooterView: UICollectionReusableView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .red
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}
