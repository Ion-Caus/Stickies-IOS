//
//  CustomShareSheet.swift
//  Stickies
//
//  Created by Ion Caus on 12.08.2023.
//

import SwiftUI

struct CustomShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    
    @Binding var url: URL
    @Binding var showing: Bool

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.showing = false
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
