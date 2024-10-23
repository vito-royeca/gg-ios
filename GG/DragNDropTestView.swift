//
//  DragNDropTestView.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DragNDropTestView: View {
    @State private var items = ["Apple", "Banana", "Lemon", "Orange"]
    @State private var draggedItem: String?

    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .background(Color.green)
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                        .frame(maxWidth: 136)
                        .padding()
                        .onDrag({
                            self.draggedItem = item
                            return NSItemProvider(item: nil, typeIdentifier: item)
                        })
                        .onDrop(of: [UTType.text], delegate: MyDropDelegate(item: item, items: $items, draggedItem: $draggedItem))
                        }
                }
        }
    }
}

struct MyDropDelegate : DropDelegate {

    let item : String
    @Binding var items : [String]
    @Binding var draggedItem : String?

    func performDrop(info: DropInfo) -> Bool {
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }

        if draggedItem != item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
}

struct DragNDropTestView2: View {
    @State var viewState = CGSize.zero

    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(Color.blue)
            .frame(width: 300, height: 400)
            .offset(x: viewState.width, y: viewState.height)
            .gesture(
                DragGesture().onChanged { value in
                    viewState = value.translation
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        viewState = .zero
                    }
                }
            )
    }
}

#Preview {
    DragNDropTestView2()
}
