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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureAsLoading() {
        nameLabel.isHidden = true
        ratingStackView.isHidden = true
        posterImageView.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    func configure(name: String, poster: URL?, starCount: Int?) {
        self.activityIndicatorView.isHidden = true
        self.activityIndicatorView.stopAnimating()
        self.posterImageView.contentMode = .scaleAspectFit
        self.posterImageView.isHidden = false
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
        nameLabel.isHidden = false
        nameLabel.text = name
        guard let starCount = starCount else {
            ratingStackView.isHidden = true
            return
        }
        ratingStackView.isHidden = false
        ratingStackView.arrangedSubviews.enumerated().forEach { (index, view) in
            let thisStarIsMet = index < starCount
            if let starImageView = view as? UIImageView {
                starImageView.image = UIImage(systemName: thisStarIsMet ? "star.fill" : "star")
            }
        }
    }

}
