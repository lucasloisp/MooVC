//
//  WithLoadingIndicator.swift
//  MoViesC
//
//  Created by Lucas Lois on 26/7/21.
//

import UIKit

protocol WithLoadingIndicator {
    var activityIndicatorView: UIActivityIndicatorView! { get }
    var viewThatHidesOnLoading: UIView? { get }
}

extension WithLoadingIndicator {
    var viewThatHidesOnLoading: UIView? { return nil }

    func startLoadingIndicator() {
        viewThatHidesOnLoading?.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    func stopLoadingIndicator() {
        viewThatHidesOnLoading?.isHidden = false
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}
