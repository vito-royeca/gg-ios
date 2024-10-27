//
//  Game.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation
import SwiftUI

enum GameAction {
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
    @Published var statusText = ""
    
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
        statusText = ""
        
        createBoard()
        deployUnits()
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
    
    func deployUnits() {
        let player1Positions = createRandomDeployment(for: player1)
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
//                let rowIndex = row-5
//                let endIndex = player2Positions.count-1
                
                for column in 0..<Game.columns {
                    for boardPosition in player2Positions[row-5 /*endIndex-rowIndex*/] {
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

    func doHumanMove(row: Int, column: Int) {
        guard !isGameOver else {
            return
        }
        
        let boardPosition = boardPositions[row][column]

        guard let selectedBoardPosition = selectedBoardPosition else {
            addPossibleActions(for: boardPosition)
            self.selectedBoardPosition = boardPositions[row][column]
            return
        }

        // same position selected, deselect
        if (selectedBoardPosition.row == boardPosition.row &&
            selectedBoardPosition.column == boardPosition.column) {
            self.selectedBoardPosition = nil
            clearPossibleActions()
            return
        }

        if boardPosition.player != nil &&
           boardPosition.unit != nil {

            guard boardPosition.action != nil else {
                addPossibleActions(for: boardPosition)
                self.selectedBoardPosition = boardPositions[row][column]
                return
            }
        } else {
            guard boardPosition.action != nil else {
                self.selectedBoardPosition = nil
                clearPossibleActions()
                return
            }
        }
        
        execute(move: GGMove(fromPosition: selectedBoardPosition,
                             toPosition: boardPosition,
                             rating: 0))
        self.selectedBoardPosition = nil
        checkGameProgress()
        doAIMove()
    }

    func checkGameProgress() {
        // check if flag is on opposite last row
//        for column in 0..<Game.columns {
//            
//        }
        
        if isGameOver {
            statusText = (winningPlayer?.isHuman ?? false) ? "VICTORY" : "DEFEAT"
        }
    }

    func addPossibleActions(for board: BoardPosition) {
        clearPossibleActions()
        
        guard let player = board.player,
              player.isHuman else {
            return
        }

        let row = board.row
        let column = board.column
        
        if row - 1 >= 0 {
            if let player = boardPositions[row-1][column].player {
                if !player.isHuman {
                    boardPositions[row-1][column].action = .fight
                }
            } else {
                boardPositions[row-1][column].action = .up
            }
        }
        
        if row + 1 <= (Game.rows - 1) {
            if let player = boardPositions[row+1][column].player {
                if !player.isHuman {
                    boardPositions[row+1][column].action = .fight
                }
            } else {
                boardPositions[row+1][column].action = .down
            }
        }
        
        if column - 1 >= 0 {
            if let player = boardPositions[row][column-1].player {
                if !player.isHuman {
                    boardPositions[row][column-1].action = .fight
                }
            } else {
                boardPositions[row][column-1].action = .left
            }
        }
        
        if column + 1 <= (Game.columns - 1) {
            if let player = boardPositions[row][column+1].player {
                if !player.isHuman {
                    boardPositions[row][column+1].action = .fight
                }
            } else {
                boardPositions[row][column+1].action = .right
            }
        }
    }
    
    func clearPossibleActions() {
        for row in 0..<Game.rows {
            for column in 0..<Game.columns {
                let boardPosition = boardPositions[row][column]

                boardPositions[row][column] = BoardPosition(row: row,
                                                            column: column,
                                                            player: boardPosition.player,
                                                            unit: boardPosition.unit)
            }
        }
    }
    
    func lastAction(from fromBoard: BoardPosition, to toBoard: BoardPosition) -> GameAction? {
        if toBoard.column == fromBoard.column {
            if toBoard.row > fromBoard.row {
                return .down
            } else {
                return .up
            }
        }
        
        if toBoard.row == fromBoard.row {
            if toBoard.column > fromBoard.column {
                return .right
            } else {
                return .left
            }
        }
        
        return nil
    }
    
    func flagPosition(of player: GGPlayer) -> BoardPosition? {
        return nil
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
    var action: GameAction?
    var isLastAction: Bool?

    init (row: Int,
          column: Int,
          player: GGPlayer? = nil,
          unit: GGUnit? = nil,
          action: GameAction? = nil,
          isLastAction: Bool? = nil) {
        self.row = row
        self.column = column
        self.player = player
        self.unit = unit
        self.action = action
        self.isLastAction = isLastAction
    }
}
