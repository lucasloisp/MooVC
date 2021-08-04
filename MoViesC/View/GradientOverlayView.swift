//
//  GradientOverlayView.swift
//  MoViesC
//
//  Created by Lucas Lois on 4/8/21.
//

import UIKit

class GradientOverlayView: UIView {

   override func draw(_ rect: CGRect) {
        super.draw(rect)
        // TODO: Still figuring out WHY the frame needs to be
        // adjusted at `draw`, and why `layoutSubvies` is not
        // sufficient.
        // The adjustment NEEDS to be made in both calls.
        self.layer.sublayers?.first?.frame = self.bounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.sublayers?.first?.removeFromSuperlayer()
        guard !self.isHidden else { return }

        let gradient = CAGradientLayer()
        gradient.name = "GradientOverlay"
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0, 1]

        self.layer.insertSublayer(gradient, at: 0)
        self.layer.masksToBounds = true
    }

}
