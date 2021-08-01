//
//  GenreMovieCollectionViewCell.swift
//  MoViesC
//
//  Created by Lucas Lois on 23/7/21.
//

import UIKit

class GenreMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    static let identifier = "GenreMovieCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name: String, poster: URL?) {
        if let url = poster {
            configureWithPoster(url: url)
        } else {
            configureWithName(name)
        }
    }

    private func configureWithPoster(url: URL) {
        posterImageView.isHidden = false
        nameLabel.isHidden = true
        posterImageView.setImageFillFromURL(url)
    }

    private func configureWithName(_ name: String) {
        nameLabel.isHidden = false
        posterImageView.isHidden = true
        posterImageView.image = nil
        nameLabel.text = name
    }

}
