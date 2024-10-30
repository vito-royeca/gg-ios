//
//  UnitsDeployerView.swift
//  GG
//
//  Created by Vito Royeca on 10/30/24.
//

import SwiftUI

struct UnitsDeployerView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: UnitsDeployerViewModel
    @State private var draggedPosition: BoardPosition?

    var body: some View {
        main().onAppear {
            viewModel.createBoard()
            viewModel.mobilizePlayer()
        }
    }
    
    @ViewBuilder
    private func main() -> some View {
        GeometryReader { reader in
            VStack(spacing: 30) {
                createBoardView(width: reader.size.width, height: reader.size.height)

                createOkButton()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GGConstants.gameViewBackgroundColor)
        }
    }
    
    @ViewBuilder
    private func createOkButton() -> some View {
        Button {
            dismiss()
        } label: {
            Text("OK")
        }
        .buttonStyle(.borderedProminent)
        .frame(height: 40)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder func createBoardView(width: CGFloat, height: CGFloat) -> some View {
        let squareWidth = width / CGFloat(GameViewModel.columns)
        let squareHeight = squareWidth

        Grid(alignment: .topLeading,
             horizontalSpacing: 1,
             verticalSpacing: 1) {
            ForEach(0..<GameViewModel.rows, id: \.self) { row in
                if row == 4 {
                    Divider()
                        .padding(1)
                }
                let color = switch row {
                case 5,6,7:
                    GGConstants.gameViewAllowedSquareColor
                default:
                    GGConstants.gameViewBannedSquareColor
                }

                GridRow {
                    ForEach(0..<GameViewModel.columns, id: \.self) { column in
                        let boardPosition = viewModel.boardPositions.isEmpty ?
                            nil :
                            viewModel.boardPositions[row][column]

                        BoardSquareView(boardPosition: boardPosition,
                                        revealUnit: true,
                                        color: color,
                                        width: squareWidth,
                                        height: squareHeight)
                            .onDrag {
                                self.draggedPosition = boardPosition
                                return NSItemProvider()
                            }
                            .onDrop(of: [.text],
                                    delegate: UnitsDeployerDropViewDelegate(destinationPosition: boardPosition,
                                                                            boardPositions: $viewModel.boardPositions,
                                                                            draggedPosition: $draggedPosition)
                            )
                        
                    }
                }

            }
        }
    }
}

struct UnitsDeployerDropViewDelegate: DropDelegate {
    let destinationPosition: BoardPosition?
    @Binding var boardPositions: [[BoardPosition]]
    @Binding var draggedPosition: BoardPosition?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedPosition = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        swapPositions()

//            let fromIndex = boardPositions.firstIndex(of: draggedPosition)
//            
//            if let fromIndex {
//                let toIndex = boardPositions.firstIndex(of: destinationPosition)
//                
//                if let toIndex, fromIndex != toIndex {
//                    withAnimation {
//                        self.boardPositions.move(fromOffsets: IndexSet(integer: fromIndex),
//                                                 toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
//                    }
//                }
//            }
//        }
    }
    
    func swapPositions() {
        guard let draggedPosition = draggedPosition,
              let destinationPosition = destinationPosition,
              (draggedPosition.row != destinationPosition.row || draggedPosition.column != destinationPosition.column),
              destinationPosition.row >= 5 else {
            return
        }

        let newPosition = BoardPosition(row: destinationPosition.row,
                                        column: destinationPosition.column,
                                        player: draggedPosition.player,
                                        unit: draggedPosition.unit)
        let emptyPosition = BoardPosition(row: draggedPosition.row,
                                          column: draggedPosition.column,
                                          player: destinationPosition.player,
                                          unit: destinationPosition.unit)

        withAnimation {
            print("Before: (\(draggedPosition.row),\(draggedPosition.column)) = \(boardPositions[draggedPosition.row][draggedPosition.column].unit?.rank)")
            print("Before: (\(destinationPosition.row),\(destinationPosition.column)) = \(boardPositions[destinationPosition.row][destinationPosition.column].unit?.rank)")
            
            boardPositions[draggedPosition.row][draggedPosition.column] = emptyPosition
            boardPositions[destinationPosition.row][destinationPosition.column] = newPosition
            
            print("After: (\(draggedPosition.row),\(draggedPosition.column)) = \(boardPositions[draggedPosition.row][draggedPosition.column].unit?.rank)")
            print("After: (\(destinationPosition.row),\(destinationPosition.column)) = \(boardPositions[destinationPosition.row][destinationPosition.column].unit?.rank)")
        }
    }
}

#Preview {
    UnitsDeployerView(viewModel: UnitsDeployerViewModel())
}
