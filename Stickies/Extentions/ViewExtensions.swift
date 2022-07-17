//
//  ViewExtensions.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import SwiftUI

// swipe back, used when NavigationBar is disabled
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
