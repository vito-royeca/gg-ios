//
//  GameViewModel.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation
import SwiftUI
import Combine

enum GameType: CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case aiVsAI, humanVsAI, humanVsHuman
    
    var name: String {
        switch self {
        case .aiVsAI:
            return "AI vs. AI"
        case .humanVsAI:
            return "Human vs. AI"
        case .humanVsHuman:
            return "Human vs. Human"
        }
    }
}

class GameViewModel: ObservableObject {
    // MARK: - Constants

    static let rows = 8
    static let columns = 9
    static let unitCount = 21

    // MARK: - Public variables

    @Published var player1 = GGPlayer(homeRow: 0)
    @Published var player2 = GGPlayer(homeRow: GameViewModel.rows - 1)
    @Published var player1Casualties = [[GGRank]]()
    @Published var player2Casualties = [[GGRank]]()
    @Published var moves = [GGMove]()
    @Published var winningPlayer: GGPlayer?
    @Published var isGameOver = true
    @Published var boardPositions = [[GGBoardPosition]]()
    @Published var selectedBoardPosition: GGBoardPosition?
    @Published var statusText = ""
    
    // MARK: - Private variables

    private var gameType: GameType
    private var onlineModel: OnlineMatchViewModel?
    private var player1Positions: [GGBoardPosition]?
    private var player2Positions: [GGBoardPosition]?
    private var activePlayer: GGPlayer?
    private var timer: Timer?
    
    // MARK: - Initializers

    init(gameType: GameType,
         onlineModel: OnlineMatchViewModel? = nil,
         player1Positions: [GGBoardPosition]? = nil,
         player2Positions: [GGBoardPosition]? = nil) {
        self.gameType = gameType
        self.onlineModel = onlineModel
        self.player1Positions = player1Positions
        self.player2Positions = player2Positions

        switch gameType{
        case .aiVsAI:
            self.player1Positions = GameViewModel.createRandomDeployment()
            self.player2Positions = GameViewModel.createRandomDeployment()
        case .humanVsAI:
            self.player1Positions = GameViewModel.createRandomDeployment()
            self.player2Positions = player2Positions
        case .humanVsHuman:
            guard let onlineModel,
                  let game = onlineModel.game,
                  let player1 = onlineModel.player1 else {
                return
            }
            
            self.player1Positions = player1.isLoggedInUser ? game.player2Positions : game.player1Positions
            self.player2Positions = player1.isLoggedInUser ? game.player1Positions : game.player2Positions
        }
    }

    // MARK: - Methods
    
    func start() {
        player1Casualties = [[GGRank]]()
        player2Casualties = [[GGRank]]()
        moves = [GGMove]()

        winningPlayer = nil
        isGameOver = false
        selectedBoardPosition = nil
        statusText = ""

        createBoard()
        deployUnits()
        
        if gameType == .aiVsAI {
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(doAIMoves),
                                         userInfo: nil,
                                         repeats: !isGameOver)
        } else if gameType == .humanVsHuman {
            if let player1ID = onlineModel?.player1?.id {
                player1.id = player1ID
            }
            if let player2ID = onlineModel?.player2?.id {
                player2.id = player2ID
            }
        }
    }
    
    func quit() {
        timer?.invalidate()
        timer = nil
        
        if let onlineModel {
            onlineModel.quitGame()
        }
    }

    func createBoard() {
        boardPositions = [[GGBoardPosition]]()
        
        for row in 0..<GameViewModel.rows {
            var rowArray = [GGBoardPosition]()
            
            for column in 0..<GameViewModel.columns {
                let boardPosition = GGBoardPosition(row: row, column: column)
                rowArray.append(boardPosition)
            }
            boardPositions.append(rowArray)
        }
    }
    
    func deployUnits() {
        // assign the player to the positions
        for boardPosition in player1Positions ?? [] {
            boardPosition.player = player1

            // invert the rows and columns for player1
            let rowCount = 3-1
            let columnCount = GameViewModel.columns-1
            let reverseRow = rowCount-boardPosition.row
            let reverseColumn = columnCount-boardPosition.column
            boardPosition.row = reverseRow
            boardPosition.column = reverseColumn
        }
        for boardPosition in player2Positions ?? [] {
            boardPosition.player = player2
        }
        
        // assign the positions to the board
        for row in 0..<GameViewModel.rows {
            let rowArray = boardPositions[row]

            switch row {
            case 0, 1, 2:
                if let player1Positions {
                    for column in 0..<GameViewModel.columns {
                        if let boardPosition = player1Positions.first(where: { $0.row == row && $0.column == column}) {
                            rowArray[column].player = boardPosition.player
                            rowArray[column].rank = boardPosition.rank
                        }
                    }
                }
                
            case 5,6,7:
                if let player2Positions {
                    for column in 0..<GameViewModel.columns {
                        if let boardPosition = player2Positions.first(where: { $0.row == row-5 && $0.column == column}) {
                            rowArray[column].player = boardPosition.player
                            rowArray[column].rank = boardPosition.rank
                        }
                    }
                }
            default:
                ()
            }
        }
    }

    @objc func doAIMoves() {
        if activePlayer == nil {
            switch Int.random(in: 0..<2) {
            case 0:
                activePlayer = player1
            default:
                activePlayer = player2
            }
        }
        
        if let activePlayer {
            checkFlagHomeRun()
            checkGameProgress()
            doAIMove(of: activePlayer)
        }
        
        if activePlayer == player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
    }

    func doAIMove(of player: GGPlayer) {
        let moves = posibleMoves(of: player)

        guard !moves.isEmpty else {
            return
        }
        
        var movesDict = [Double: [GGMove]]()
        moves.forEach {
            if var array = movesDict[$0.rating] {
                array.append($0)
                movesDict[$0.rating] = array
            } else {
                movesDict[$0.rating] = [$0]
            }
        }
        let ratingKeys = movesDict.keys.sorted(by: { $0 > $1 })
        if let first = ratingKeys.first,
            let highestMoves = movesDict[first] {
            let randomIndex = Int.random(in: 0..<highestMoves.count)
            let randomMove = highestMoves[randomIndex]

            execute(move: randomMove)
        } else {
            let randomIndex = Int.random(in: 0..<moves.count)
            let randomMove = moves[randomIndex]
            
            execute(move: randomMove)
        }
        
        checkFlagHomeRun()
        checkGameProgress()
    }

    func doHumanMove(row: Int, column: Int) {
        guard !isGameOver else {
            return
        }
        
//        if gameType == .humanVsHuman {
//            guard let game,
//                game.activePlayerID == player2ID else {
//                return
//            }
//        }
        
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
           boardPosition.rank != nil {

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
        
        let move = GGMove(fromPosition: selectedBoardPosition,
                          toPosition: boardPosition)
        execute(move: move)
        self.selectedBoardPosition = nil
        
        checkFlagHomeRun()
        checkGameProgress()
        
        if gameType == .humanVsAI {
            doAIMove(of: !player1.isBottomPlayer ? player1 : player2)
        } else if gameType == .humanVsHuman {
            onlineModel?.send(lastMove: move, listenHandler: doOnlineMove)
        }
    }
    
    func doOnlineMove() {
        guard let game = onlineModel?.game,
              let lastMove = game.lastMove,
              let player = lastMove.fromPosition.player,
              player.id != player2.id else {
            return
        }
        
        execute(move: lastMove)
        checkFlagHomeRun()
        checkGameProgress()
    }

    func checkGameProgress() {
        if isGameOver {
            switch gameType {
            case .aiVsAI:
                statusText = (winningPlayer?.homeRow == 0) ? "BLACK WINS" : "WHITE WINS"
            case .humanVsAI:
                statusText = (winningPlayer?.homeRow == GameViewModel.rows - 1) ? "VICTORY" : "DEFEAT"
            case .humanVsHuman:
                statusText = (winningPlayer?.homeRow == GameViewModel.rows - 1) ? "VICTORY" : "DEFEAT"
            }
            print("Game Over: \(statusText)")

            timer?.invalidate()
            timer = nil
        }
    }

    func checkFlagHomeRun() {
        if isGameOver {
            return
        }

        // check if flag is on opposite last row
        for row in 0..<GameViewModel.rows {
            for column in 0..<GameViewModel.columns {
                let boardPosition = boardPositions[row][column]

                if let player = boardPosition.player,
                   let rank = boardPosition.rank,
                   rank == .flag {
                    isGameOver = player.isBottomPlayer ?
                        boardPosition.row == 0 :
                        boardPosition.row == GameViewModel.rows - 1

                    if isGameOver {
                        winningPlayer = player
                        return
                    }
                }
            }
        }
    }
    
    func topPosition(from board: GGBoardPosition) -> GGBoardPosition? {
        if board.row - 1 >= 0 {
            return boardPositions[board.row-1].first(where: { $0.column == board.column })
        }
        return nil
    }

    func bottomPosition(from board: GGBoardPosition) -> GGBoardPosition? {
        if board.row + 1 <= (GameViewModel.rows - 1) {
            return boardPositions[board.row+1].first(where: { $0.column == board.column })
        }
        return nil
    }

    func leftPosition(from board: GGBoardPosition) -> GGBoardPosition? {
        if board.column - 1 >= 0 {
            return boardPositions[board.row].first(where: { $0.column == board.column-1 })
        }
        return nil
    }

    func rightPosition(from board: GGBoardPosition) -> GGBoardPosition? {
        if board.column + 1 <= (GameViewModel.columns - 1) {
            return boardPositions[board.row].first(where: { $0.column == board.column+1 })
        }
        return nil
    }
}
 
