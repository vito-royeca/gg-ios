//
//  GeometryReaderView.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import SwiftUI

struct GeometryReaderView: View {
    @State private var size: CGSize = .zero

    var body: some View {
        ZStack {
            Text("Hello World: \(size.width)x\(size.height)")
                .background(Color.pink)
                .frame(width: size.width, height: size.height)
        }
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newSize in
            size = newSize
        }
    }
}

#Preview {
    GeometryReaderView()
}
