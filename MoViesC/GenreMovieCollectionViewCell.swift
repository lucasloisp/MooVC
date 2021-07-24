//
//  GenreMovieCollectionViewCell.swift
//  MoViesC
//
//  Created by Lucas Lois on 23/7/21.
//

import UIKit
import Kingfisher

class GenreMovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "GenreMovieCollectionViewCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name: String, poster: URL?) {
        guard let url = poster else {
            posterImageView.image = nil
            nameLabel.text = name
            nameLabel.isHidden = false
            posterImageView.isHidden = true
            return
        }
        let placeholder = UIImage(systemName: "photo")
        posterImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        nameLabel.text = ""
        nameLabel.isHidden = true
        posterImageView.isHidden = false
    }

}
