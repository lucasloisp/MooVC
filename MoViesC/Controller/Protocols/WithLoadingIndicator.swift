//
//  WithLoadingIndicator.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

protocol WithLoadingIndicator {
    var activityIndicatorView: UIActivityIndicatorView! { get }
}

extension WithLoadingIndicator {
    func startLoadingIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    func stopLoadingIndicator() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}
