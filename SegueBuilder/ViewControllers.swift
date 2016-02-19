//
//  ViewController.swift
//  SegueBuilder
//
//  Created by Ian Terrell on 2/18/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

final class A: UIViewController {
    var dependency: String!

    static func build(dependency dependency: String) -> A {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("InitialA") as! A
        controller.prepare(dependency: dependency)
        return controller
    }

    func prepare(dependency dependency: String) {
        self.dependency = dependency
    }

    @IBAction func pushManually() {
        performSegue(.ToB, sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueFromStoryboardSegue(segue) {
        case .ToB(let b):
            b.prepare(dependency: "injected from a")
        }
    }

    override func viewDidAppear(animated: Bool) {
        print("\(self.dynamicType): \(dependency)")
    }
}

extension A: SegueHandler {
    enum SegueIdentifier: String {
        case ToB
    }

    enum ToSegueDestination: SegueDestination {
        case ToB(B)

        init?(identifier: SegueIdentifier, destination: UIViewController) {
            switch identifier {
            case .ToB:
                guard let b = destination as? B else { return nil }
                self = .ToB(b)
            }
        }
    }
}

final class B: UIViewController {
    var dependency: String!

    func prepare(dependency dependency: String) {
        self.dependency = dependency
    }

    override func viewDidAppear(animated: Bool) {
        print("\(self.dynamicType): \(dependency)")
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueFromStoryboardSegue(segue) {
        case .ToCViaNav(let c):
            c.prepare(dependency: "injected from b")
        }
    }
}

extension B: SegueHandler {
    enum SegueIdentifier: String {
        case ToCViaNav
    }

    enum ToSegueDestination: SegueDestination {
        case ToCViaNav(C)

        init?(identifier: SegueIdentifier, destination: UIViewController) {
            switch identifier {
            case .ToCViaNav:
                guard let nav = destination as? UINavigationController else { return nil }
                guard let c = nav.viewControllers.first as? C else { return nil }
                self = .ToCViaNav(c)
            }
        }
    }
}

final class C: UIViewController {
    var dependency: String!

    func prepare(dependency dependency: String) {
        self.dependency = dependency
    }

    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidAppear(animated: Bool) {
        print("\(self.dynamicType): \(dependency)")
    }
}

