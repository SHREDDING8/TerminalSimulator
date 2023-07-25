//
//  UITextView.swift
//  TerminalSimulator
//
//  Created by SHREDDING on 12.07.2023.
//

import Foundation
import UIKit

extension UITextView {
    func addLeftRightToolBar(onLeft: (target: Any, action: Selector)? = nil, onRight: (target: Any, action: Selector)? = nil) {
        let onRight = onRight ?? (target: self, action: #selector(cancelButtonTapped))
        let onLeft = onLeft ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: onLeft.target, action: onLeft.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .done, target: onRight.target, action: onRight.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
