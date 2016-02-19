//
//  SegueHandler.swift
//  SegueBuilder
//
//  Created by Ian Terrell on 2/18/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

protocol SegueDestination {
    typealias SegueIdentifier: RawRepresentable
    init?(identifier: SegueIdentifier, destination: UIViewController)
}

protocol SegueHandler {
    typealias SegueIdentifier: RawRepresentable
    typealias ToSegueDestination: SegueDestination
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String, SegueIdentifier == ToSegueDestination.SegueIdentifier {
    func performSegue(segue: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segue.rawValue, sender: sender)
    }

    func segueFromStoryboardSegue(segue: UIStoryboardSegue) -> ToSegueDestination {
        guard let id = segue.identifier,
              let identifier = SegueIdentifier(rawValue: id)
        else {
            preconditionFailure("Invalid segue identifier: \(segue.identifier).")
        }

        guard let segueIdentifier = ToSegueDestination(identifier: identifier, destination: segue.destinationViewController)
        else {
            preconditionFailure("Wrong type for segue '\(id)': \(segue.destinationViewController.dynamicType).")
        }
        return segueIdentifier
    }
}
