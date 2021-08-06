//
//  GradientOverlayView.swift
//  MoViesC
//
//  Created by Lucas Lois on 4/8/21.
//

import UIKit

class GradientOverlayView: UIView {

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.name = "GradientOverlay"
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0, 1]
        return gradient
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard !self.isHidden else { return }
        gradientLayer.frame = self.bounds
    }

}
