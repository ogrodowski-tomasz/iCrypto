//
//  XMarkButton.swift
//  iCrypto
//
//  Created by Tomasz Ogrodowski on 26/04/2022.
//

import SwiftUI

struct XMarkButton: View {
    var body: some View {
        Image(systemName: "xmark")
            .font(.headline)
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
