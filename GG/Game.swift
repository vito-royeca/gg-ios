//
//  Game.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation
import SwiftUI

enum GameMove {
    case up, left, down, right, fight
}

class Game: ObservableObject {
    static let rows = 8
    static let columns = 9
    static let unitCount = 21
    
    @Published var player1 = GGPlayer()
    @Published var player2 = GGPlayer()
    @Published var player1Casualties = [[GGUnit]]()
    @Published var player2Casualties = [[GGUnit]]()
    @Published var winningPlayer: GGPlayer?
    @Published var isGameOver = true
    @Published var boardPositions = [[BoardPosition]]()
    @Published var selectedBoardPosition: BoardPosition?
    @Published var statusText = " "
    
    func start() {
        player1 = GGPlayer()
        player1.mobilize()

        player2 = GGPlayer()
        player2.mobilize()
        player2.isHuman = true

        player1Casualties = [[GGUnit]]()
        player2Casualties = [[GGUnit]]()
        winningPlayer = nil
        isGameOver = false
        selectedBoardPosition = nil
        statusText = " "
        
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
                rowArray[1].player = player1
                rowArray[2].player = player1
                rowArray[3].player = player1
                rowArray[4].player = player1
                rowArray[5].player = player1
                rowArray[6].player = player1
                rowArray[7].player = player1
                
            case 1:
                rowArray[1].unit = player1.spyA
                rowArray[2].unit = player1.spyB
                rowArray[3].unit = player1.sergeant
                rowArray[4].unit = player1.lieutenant1
                rowArray[5].unit = player1.lieutenant2
                rowArray[6].unit = player1.captain
                rowArray[7].unit = player1.major
                rowArray[1].player = player1
                rowArray[2].player = player1
                rowArray[3].player = player1
                rowArray[4].player = player1
                rowArray[5].player = player1
                rowArray[6].player = player1
                rowArray[7].player = player1
            case 2:
                rowArray[1].unit = player1.colonel1
                rowArray[2].unit = player1.colonel2
                rowArray[3].unit = player1.general1
                rowArray[4].unit = player1.general2
                rowArray[5].unit = player1.general3
                rowArray[6].unit = player1.general4
                rowArray[7].unit = player1.general5
                rowArray[1].player = player1
                rowArray[2].player = player1
                rowArray[3].player = player1
                rowArray[4].player = player1
                rowArray[5].player = player1
                rowArray[6].player = player1
                rowArray[7].player = player1
            
            // player 2
            case 5:
                rowArray[1].unit = player2.colonel1
                rowArray[2].unit = player2.colonel2
                rowArray[3].unit = player2.general1
                rowArray[4].unit = player2.general2
                rowArray[5].unit = player2.general3
                rowArray[6].unit = player2.general4
                rowArray[7].unit = player2.general5
                rowArray[1].player = player2
                rowArray[2].player = player2
                rowArray[3].player = player2
                rowArray[4].player = player2
                rowArray[5].player = player2
                rowArray[6].player = player2
                rowArray[7].player = player2
            case 6:
                rowArray[1].unit = player2.spyA
                rowArray[2].unit = player2.spyB
                rowArray[3].unit = player2.sergeant
                rowArray[4].unit = player2.lieutenant1
                rowArray[5].unit = player2.lieutenant2
                rowArray[6].unit = player2.captain
                rowArray[7].unit = player2.major
                rowArray[1].player = player2
                rowArray[2].player = player2
                rowArray[3].player = player2
                rowArray[4].player = player2
                rowArray[5].player = player2
                rowArray[6].player = player2
                rowArray[7].player = player2
            case 7:
                rowArray[1].unit = player2.flag
                rowArray[2].unit = player2.privateA
                rowArray[3].unit = player2.privateB
                rowArray[4].unit = player2.privateC
                rowArray[5].unit = player2.privateD
                rowArray[6].unit = player2.privateE
                rowArray[7].unit = player2.privateF
                rowArray[1].player = player2
                rowArray[2].player = player2
                rowArray[3].player = player2
                rowArray[4].player = player2
                rowArray[5].player = player2
                rowArray[6].player = player2
                rowArray[7].player = player2
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
                let boardPosition = BoardPosition(row: row, column: column)
                rowArray.append(boardPosition)
            }
            boardPositions.append(rowArray)
        }
    }
    
    func handleTap(row: Int, column: Int) {
        guard !isGameOver else {
            return
        }
        
        let boardPosition = boardPositions[row][column]
        statusText = ""
        
        guard let selectedBoardPosition = selectedBoardPosition else {
            addPossibleMoves(for: boardPosition)
            self.selectedBoardPosition = boardPositions[row][column]
            return
        }

        if let player = boardPosition.player,
           let unit = boardPosition.unit {

            if (selectedBoardPosition.row == boardPosition.row && selectedBoardPosition.column == boardPosition.column) {
                self.selectedBoardPosition = nil
                removeAllPossibleMoves()
                return
            }
            
            guard boardPosition.possibleMove != nil else {
                addPossibleMoves(for: boardPosition)
                self.selectedBoardPosition = boardPositions[row][column]
                return
            }
            
            guard let myPlayer = selectedBoardPosition.player,
                  let myUnit = selectedBoardPosition.unit else {
                return
            }
            
            let (winningPlayer, winningUnit, isGameOver) = handleFight(player: myPlayer,
                                                                       unit: myUnit,
                                                                       vs: player,
                                                                       with: unit)
            
            let newBoardPosition = BoardPosition(row: row,
                                                 column: column,
                                                 player: winningPlayer,
                                                 unit: winningUnit,
                                                 possibleMove: nil)
            let emptyBoardPosition = BoardPosition(row: selectedBoardPosition.row,
                                                   column: selectedBoardPosition.column)
            boardPositions[selectedBoardPosition.row][selectedBoardPosition.column] = emptyBoardPosition
            boardPositions[row][column] = newBoardPosition
            self.selectedBoardPosition = nil
            self.winningPlayer = winningPlayer
            self.isGameOver = isGameOver
            updateCasualties()
        } else {
            guard boardPosition.possibleMove != nil else {
                self.selectedBoardPosition = nil
                removeAllPossibleMoves()
                return
            }
            
            let newBoardPosition = BoardPosition(row: row,
                                                 column: column,
                                                 player: selectedBoardPosition.player,
                                                 unit: selectedBoardPosition.unit,
                                                 possibleMove: nil)
            let emptyBoardPosition = BoardPosition(row: selectedBoardPosition.row,
                                                   column: selectedBoardPosition.column)
            boardPositions[selectedBoardPosition.row][selectedBoardPosition.column] = emptyBoardPosition
            boardPositions[row][column] = newBoardPosition
            self.selectedBoardPosition = nil
            
        }
        
        removeAllPossibleMoves()
        checkGameProgress()
    }
    
    func handleFight(player: GGPlayer, unit: GGUnit, vs player2: GGPlayer, with unit2: GGUnit) -> (GGPlayer?, GGUnit?, Bool) {
        let result = unit.challenge(other: unit2)
        
        switch result.challengeResult {
        case .win:
            player2.destroy(unit: unit2)
            return (player, unit, result.isGameOver)
        case .loose:
            player.destroy(unit: unit)
            return (player2, unit2, result.isGameOver)
        case .draw:
            player.destroy(unit: unit)
            player2.destroy(unit: unit2)
            return (nil, nil, result.isGameOver)
        }
    }

    func checkGameProgress() {
        if isGameOver {
            statusText = (winningPlayer?.isHuman ?? false) ? " Victory" : " Defeat"
        }
    }

    func addPossibleMoves(for board: BoardPosition) {
        removeAllPossibleMoves()
        
        guard let player = board.player,
              player.isHuman else {
            return
        }

        let row = board.row
        let column = board.column
        
        if row - 1 >= 0 {
            if let player = boardPositions[row-1][column].player {
                if !player.isHuman {
                    boardPositions[row-1][column].possibleMove = .fight
                }
            } else {
                boardPositions[row-1][column] = BoardPosition(row: row,
                                                              column: column,
                                                              possibleMove: .up)
            }
        }
        
        if row + 1 <= (Game.rows - 1) {
            if let player = boardPositions[row+1][column].player {
                if !player.isHuman {
                    boardPositions[row+1][column].possibleMove = .fight
                }
            } else {
                boardPositions[row+1][column] = BoardPosition(row: row,
                                                              column: column,
                                                              possibleMove: .down)
            }
        }
        
        if column - 1 >= 0 {
            if let player = boardPositions[row][column-1].player {
                if !player.isHuman {
                    boardPositions[row][column-1].possibleMove = .fight
                }
            } else {
                boardPositions[row][column-1] = BoardPosition(row: row,
                                                              column: column,
                                                              possibleMove: .left)
            }
        }
        
        if column + 1 <= (Game.columns - 1) {
            if let player = boardPositions[row][column+1].player {
                if !player.isHuman {
                    boardPositions[row][column+1].possibleMove = .fight
                }
            } else {
                boardPositions[row][column+1] = BoardPosition(row: row,
                                                              column: column,
                                                              possibleMove: .right)
            }
        }
    }
    
    func removeAllPossibleMoves() {
        for row in 0..<Game.rows {
            for column in 0..<Game.columns {
                let boardPosition = boardPositions[row][column]

                if boardPosition.possibleMove != nil {
                    boardPositions[row][column] = BoardPosition(row: row,
                                                                column: column,
                                                                player: boardPosition.player,
                                                                unit: boardPosition.unit,
                                                                possibleMove: nil)
                }
            }
        }
    }
}

extension Game {
    func updateCasualties() {
        player1Casualties = [[GGUnit]]()
        player2Casualties = [[GGUnit]]()
        
        var rowArray = [GGUnit]()
        var count = 0
        
        for casualty in player1.casualties {
            rowArray.append(casualty)
            count += 1

            if count == 7 {
                player1Casualties.append(rowArray)
                rowArray = [GGUnit]()
                count = 0
            }
        }
        player1Casualties.append(rowArray)
        
        rowArray = [GGUnit]()
        count = 0
        
        for casualty in player2.casualties {
            rowArray.append(casualty)
            count += 1

            if count == 7 {
                player2Casualties.append(rowArray)
                rowArray = [GGUnit]()
                count = 0
            }
        }
        player2Casualties.append(rowArray)
    }
}

class BoardPosition {
    var row: Int
    var column: Int
    var player: GGPlayer?
    var unit: GGUnit?
    var possibleMove: GameMove?

    init (row: Int,
          column: Int,
          player: GGPlayer? = nil,
          unit: GGUnit? = nil,
          possibleMove: GameMove? = nil) {
        self.row = row
        self.column = column
        self.player = player
        self.unit = unit
        self.possibleMove = possibleMove
    }
}
