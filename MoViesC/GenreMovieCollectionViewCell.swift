//
//  GenreMovieCollectionViewCell.swift
//  MoViesC
//
//  Created by December on 23/7/21.
//

import UIKit

class GenreMovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "GenreMovieCollectionViewCell"

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name: String, poster: UIImage?) {
        movieNameLabel.text = name
        posterImageView.image = poster

    }

}
