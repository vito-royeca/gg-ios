//
//  Game.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation
import SwiftUI

class Game: ObservableObject {
    static let rows = 8
    static let columns = 9
    
    @Published var player1 = Player()
    @Published var player2 = Player()
    @Published var boardPositions = [[BoardPosition]]()
    
    func setup() {
        player1.createUnits()
        player2.createUnits()
        createBoard()
        
        for row in 0..<Game.rows {
            let rowArray = boardPositions[row];

            switch row {
            // player 1
            case 0:
                rowArray[1].unit = player1.flag
                rowArray[2].unit = player1.privateA
                rowArray[3].unit = player1.privateB
                rowArray[4].unit = player1.privateC
                rowArray[5].unit = player1.privateD
                rowArray[6].unit = player1.privateE
                rowArray[7].unit = player1.privateF
            case 1:
                rowArray[1].unit = player1.spyA
                rowArray[2].unit = player1.spyB
                rowArray[3].unit = player1.sergeant
                rowArray[4].unit = player1.lieutenant1
                rowArray[5].unit = player1.lieutenant2
                rowArray[6].unit = player1.captain
                rowArray[7].unit = player1.major
            case 2:
                rowArray[1].unit = player1.colonel1
                rowArray[2].unit = player1.colonel2
                rowArray[3].unit = player1.general1
                rowArray[4].unit = player1.general2
                rowArray[5].unit = player1.general3
                rowArray[6].unit = player1.general4
                rowArray[7].unit = player1.general5
            
            // player 2
            case 5:
                rowArray[1].unit = player2.colonel1
                rowArray[2].unit = player2.colonel2
                rowArray[3].unit = player2.general1
                rowArray[4].unit = player2.general2
                rowArray[5].unit = player2.general3
                rowArray[6].unit = player2.general4
                rowArray[7].unit = player2.general5
            case 6:
                rowArray[1].unit = player2.spyA
                rowArray[2].unit = player2.spyB
                rowArray[3].unit = player2.sergeant
                rowArray[4].unit = player2.lieutenant1
                rowArray[5].unit = player2.lieutenant2
                rowArray[6].unit = player2.captain
                rowArray[7].unit = player2.major
            case 7:
                rowArray[1].unit = player2.flag
                rowArray[2].unit = player2.privateA
                rowArray[3].unit = player2.privateB
                rowArray[4].unit = player2.privateC
                rowArray[5].unit = player2.privateD
                rowArray[6].unit = player2.privateE
                rowArray[7].unit = player2.privateF
            default:
                ()
            }
        }
    }
    
    func createBoard() {
        boardPositions = [[BoardPosition]]()
        
        for row in 0..<Game.rows {
            var rowArray = [BoardPosition]()
            
            for column in 0..<Game.columns {
                let boardPosition = BoardPosition(row: row, column: column, unit: nil)
                rowArray.append(boardPosition)
            }
            boardPositions.append(rowArray)
        }
    }
}

class BoardPosition {
    var row: Int
    var column: Int
    var unit: GGUnit?
    
    init (row: Int, column: Int, unit: GGUnit?) {
        self.row = row
        self.column = column
        self.unit = unit
    }
}
