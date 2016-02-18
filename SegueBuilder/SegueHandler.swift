//
//  SegueHandler.swift
//  SegueBuilder
//
//  Created by Ian Terrell on 2/18/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

protocol SegueType {
    init?(identifier: String, destination: UIViewController?)
    var identifier: String { get }
}

protocol SegueHandler {
    typealias Segue: SegueType
}

extension SegueHandler where Self: UIViewController {
    func performSegue(segue: Segue, sender: AnyObject?) {
        performSegueWithIdentifier(segue.identifier, sender: sender)
    }

    func segueFromStoryboardSegue(segue: UIStoryboardSegue) -> Segue {
        guard let identifier = segue.identifier,
              let segueIdentifier = Segue(identifier: identifier, destination: segue.destinationViewController)
        else {
            preconditionFailure("Invalid segue: \(segue.identifier).")
        }
        return segueIdentifier
    }
}
