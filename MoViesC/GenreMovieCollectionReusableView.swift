//
//  GenreMovieCollectionReusableView.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

protocol GenreMovieCollectionReusableViewDelegate: AnyObject {
    func didTap()
}

class GenreMovieCollectionReusableView: UICollectionReusableView {
    static let identifier = "GenreMovieCollectionReusableView"

    weak var delegate: GenreMovieCollectionReusableViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func requestMore(_ sender: Any) {
        delegate?.didTap()
    }

}
