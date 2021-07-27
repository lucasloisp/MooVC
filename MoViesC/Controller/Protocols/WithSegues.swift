//
//  WithSegues.swift
//  MoViesC
//
//  Created by Lucas Lois on 25/7/21.
//

import UIKit

protocol PerformableSegue {
    var identifier: String { get }
}

protocol WithSegues: UIViewController {
    associatedtype SegueType: PerformableSegue
}

extension WithSegues {
    func perform(segue: SegueType) {
        performSegue(withIdentifier: segue.identifier, sender: nil)
    }
}

// PerformableSegue's defined as an enum (string-representable) map to identifiers implicitly
extension PerformableSegue where Self: RawRepresentable, RawValue == String {
    var identifier: String {
        return self.rawValue
    }
}
