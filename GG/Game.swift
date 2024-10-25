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
        deployPlayerUnits()
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
    
    func deployPlayerUnits() {
        let player1Positions = createStandardDeployment(for: player1)
        let player2Positions = createStandardDeployment(for: player2)
        
        for row in 0..<Game.rows {
            let rowArray = boardPositions[row]

            switch row {
            // player 1
            case 0, 1, 2:
                for column in 0..<Game.columns {
                    for boardPosition in player1Positions[row] {
                        if boardPosition.column == column {
                            rowArray[column].player = boardPosition.player
                            rowArray[column].unit = boardPosition.unit
                        }
                    }
                }
                
            // player 2
            case 5,6,7:
                // mirror player2's deployment
                let rowIndex = row-5
                let endIndex = player2Positions.count-1
                
                for column in 0..<Game.columns {
                    for boardPosition in player2Positions[endIndex-rowIndex] {
                        if boardPosition.column == column {
                            rowArray[column].player = boardPosition.player
                            rowArray[column].unit = boardPosition.unit
                        }
                    }
                }

            default:
                ()
            }
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
        
        doAIMove()
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
            statusText = (winningPlayer?.isHuman ?? false) ? " VICTORY" : " DEFEAT"
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
