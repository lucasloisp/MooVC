//
//  WithLoadingIndicator.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

protocol WithLoadingIndicator {
    var activityIndicatorView: UIActivityIndicatorView! { get }
    var viewsThatHideOnLoading: [UIView] { get }
}

extension WithLoadingIndicator {

    func startLoadingIndicator() {
        viewsThatHideOnLoading.forEach { $0.isHidden = true }
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    func stopLoadingIndicator() {
        viewsThatHideOnLoading.forEach { $0.isHidden = false }
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}
