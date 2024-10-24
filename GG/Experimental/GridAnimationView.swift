//
//  GridAnimationView.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import SwiftUI

struct GridAnimationView: View {
    @StateObject private var viewModel = DotManager()
    @Namespace private var nsDots // ADDED
    @State private var showingCombined = false // ADDED

    private func gridOfDots(dots: [Dot], color: Color, showWhenCombined: Bool) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 5)) {
            ForEach(dots) { dot in
                dot.dot
                    .frame(width: 20, height: 20)
                    .foregroundStyle(color)
                    .opacity(showingCombined == showWhenCombined ? 1 : 0)
                    .matchedGeometryEffect(
                        id: dot.id,
                        in: nsDots,
                        isSource: showWhenCombined == showingCombined
                    )
            }
        }
    }

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    gridOfDots(dots: viewModel.blueDots, color: .blue, showWhenCombined: false)
                    gridOfDots(dots: viewModel.redDots, color: .red, showWhenCombined: false)
                }
                gridOfDots(dots: viewModel.combinedDots, color: .purple, showWhenCombined: true)
            }
            .animation(.easeIn(duration: 1), value: showingCombined)

            HStack(spacing: 30) {
                Button("Fill") {
                    withAnimation { viewModel.addDots() }
                }

                Button {
                    showingCombined.toggle()
                } label: {
                    ZStack {
                        Text("Split").opacity(showingCombined ? 1 : 0)
                        Text("Combine").opacity(showingCombined ? 0 : 1)
                    }
                }

                Button("Clear") {
                    withAnimation { viewModel.reset() }
                }
            }
            .padding()
            .foregroundStyle(.primary)
            .background(.background)
        }
        .padding()
    }
}

enum DotType {
    case blue, red, combined
}

class Dot: Identifiable {
    let id = UUID()
    let dot = Circle()
}

class DotManager: ObservableObject {
    @Published var blueDots: [Dot] = []
    @Published var redDots: [Dot] = []
    @Published var combinedDots: [Dot] = []

    func addDots() {
        for _ in 0..<17 {
            let newDot = Dot()
            blueDots.append(newDot)
            combinedDots.append(newDot)
        }
        for _ in 17..<28 {
            let newDot = Dot()
            redDots.append(newDot)
            combinedDots.append(newDot)
        }
        combinedDots.shuffle()
    }

    func reset() {
        blueDots.removeAll()
        redDots.removeAll()
        combinedDots.removeAll()
    }
}

#Preview {
    GridAnimationView()
}
