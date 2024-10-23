//
//  BattlefieldView.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import SwiftUI

struct BattlefieldView: View {
    @ObservedObject var game = Game()
    
    var body: some View {
        VStack {
            boardView
            Button {
                game.setup()
            } label: {
                Text("New Game")
            }
        }
    }
    
    var boardView: some View {
        GeometryReader { reader in
            let width = reader.size.width / CGFloat(Game.columns)
            let height = width

            if game.boardPositions.isEmpty {
                Text("Create new game")
            } else {
                Grid(alignment: .topLeading,
                     horizontalSpacing: 1,
                     verticalSpacing: 1) {
                    ForEach(0..<Game.rows) { row in
                        let color:Color = switch row {
                        case 0,1,2:
                            .black
                        case 5,6,7:
                            .black
                        default:
                            .secondary
                        }
                        
                        let isHumanPlayer:Bool = switch row {
                        case 0,1,2:
                            false
                        default:
                            true
                        }
                        
                        GridRow {
                            ForEach(0..<Game.columns) { column in
                                let unit =  game.boardPositions[row][column].unit
                                
                                BoardSquareView(unit: unit,
                                                row: row,
                                                column: column,
                                                color: color,
                                                tintColor: isHumanPlayer ? Color.red : Color.blue,
                                                width: width,
                                                height: height)
                            }
                        }
                    }
                }
            }
            
        }
    }
}

struct BoardSquareView: View {
    @State var unit: GGUnit?
    let row: Int
    let column: Int
    let color: Color
    let tintColor: Color
    let width: CGFloat
    let height: CGFloat

    @State private var location = CGPoint.zero
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
    }
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
    }
    
    var body: some View {
        ZStack {
            color
            
            if let unit = unit {
                Image("\(unit.iconName)-white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: location.x, y: location.y)
                    .gesture(
                        simpleDrag.simultaneously(with: fingerDrag)
                    )
                if let fingerLocation = fingerLocation {
                    Circle()
                        .stroke(Color.green, lineWidth: 2)
                        .frame(width: width/2, height: height/2)
                        .position(fingerLocation)
                }
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    BattlefieldView()
}
