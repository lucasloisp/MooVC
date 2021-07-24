//
//  MovieDetailsViewController.swift
//  MoViesC
//
//  Created by Lucas Lois on 24/7/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    let movie: Movie

    required init?(coder: NSCoder) {
      fatalError("init(coder:) is not implemented")
    }

    init?(coder: NSCoder, for movie: Movie) {
      self.movie = movie
      super.init(coder: coder)
      self.title = movie.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
