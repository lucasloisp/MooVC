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

    func configure(name: String, poster: URL?, starCount: Int) {
        guard let url = poster else {
            posterImageView.image = nil
            nameLabel.text = name
            nameLabel.isHidden = false
            posterImageView.isHidden = true
            return
        }
        let placeholder = UIImage(systemName: "photo")
        self.posterImageView.contentMode = .scaleAspectFit
        posterImageView.kf.setImage(with: url, placeholder: placeholder, options: nil) { result in
            switch result {
            case .success(_):
                self.posterImageView.contentMode = .scaleAspectFill
            default:
                return
            }
        }
        nameLabel.text = ""
        nameLabel.isHidden = true
        posterImageView.isHidden = false
        ratingStackView.arrangedSubviews.enumerated().forEach { (index, view) in
            let starValue = index + 1
            view.isHidden = starValue > starCount
        }
    }

}
