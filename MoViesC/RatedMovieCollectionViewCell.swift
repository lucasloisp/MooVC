//
//  RatedMovieCollectionViewCell.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit
import Kingfisher

class RatedMovieCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "RatedMovieCollectionViewCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name: String, poster: URL?, starCount: Int?) {
        self.posterImageView.contentMode = .scaleAspectFit
        if let url = poster {
            let placeholder = UIImage(systemName: "photo")
            posterImageView.kf.setImage(with: url, placeholder: placeholder, options: nil) { result in
                switch result {
                case .success(_):
                    self.posterImageView.contentMode = .scaleAspectFill
                default:
                    return
                }
            }
        } else {
            self.posterImageView.image = UIImage(systemName: "xmark.rectangle.fill")
        }
        nameLabel.text = name
        guard let starCount = starCount else {
            ratingStackView.isHidden = true
            return
        }
        ratingStackView.arrangedSubviews.enumerated().forEach { (index, view) in
            let thisStarIsMet = index < starCount
            if let starImageView = view as? UIImageView {
                starImageView.image = UIImage(systemName: thisStarIsMet ? "star.fill" : "star")
            }
        }
    }

}
