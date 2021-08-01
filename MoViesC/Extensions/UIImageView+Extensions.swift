//
//  UIImageView+Extensions.swift
//  MoViesC
//
//  Created by Lucas Lois on 1/8/21.
//

import UIKit

private let placeholder = UIImage(systemName: "photo")

extension UIImageView {
    public func setImageFillFromURL(_ url: URL) {
        self.contentMode = .scaleAspectFit
        self.kf.setImage(with: url, placeholder: placeholder, options: nil) { result in
            switch result {
            case .success(_):
                self.contentMode = .scaleAspectFill
            default:
                return
            }
        }
    }
}
