//
//  CircleButtonAnimationView.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 19/04/2022.
//

import SwiftUI

struct CircleButtonAnimationView: View {

    @Binding var animate: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scaleEffect(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
    }
}
