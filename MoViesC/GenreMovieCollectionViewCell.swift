//
//  GenreMovieCollectionViewCell.swift
//  MoViesC
//
//  Created by Lucas Lois on 23/7/21.
//

import UIKit

class GenreMovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "GenreMovieCollectionViewCell"

    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name: String, poster: URL?) {
        guard let url = poster else {
            posterImageView.image = UIImage(systemName: "xmark.rectangle")
            // TODO: Set the title as if it were the picture
            return
        }
        let placeholder = UIImage(systemName: "photo")
        posterImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
    }

}
