//
//  Indicator.swift
//  Pics
//
//  Created by factboii on 29.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class Indicator: UIView {

    let shapeLayer = CAShapeLayer()

    private func setupIndicator() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2, y: bounds.size.width / 2), radius: bounds.width/3, startAngle: 0, endAngle: 3 * .pi / 2, clockwise: true)
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 2.0
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupIndicator()
    }
    
    func startIndicator() {
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.duration = 1
        animate.repeatCount = .infinity
        animate.fromValue = 0.0
        animate.toValue = 2.0 * Double.pi
        layer.add(animate, forKey: nil)
        isHidden = false
    }
    
    func stopIndicator() {
        layer.removeAllAnimations()
        isHidden = true
    }
    
}
