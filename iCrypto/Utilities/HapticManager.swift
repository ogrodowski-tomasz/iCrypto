//
//  HapticManager.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 26/04/2022.
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
