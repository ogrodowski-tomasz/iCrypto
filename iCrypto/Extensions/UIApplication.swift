//
//  UIApplication.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 25/04/2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        // #selector(UIResponder.resignFirstResponder): obj-c method that will dismiss the keyboard after clicking on X button
    }
}
