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
            String(localized: "GameType.aiVsAI")
        case .humanVsAI:
            String(localized: "GameType.humanVsAI")
        case .humanVsHuman:
            String(localized: "GameType.humanVsHuman")
        }
    }
}

class GameViewModel: ObservableObject {
    // MARK: - Constants

    static let rows = 8
    static let columns = 9
    static let unitCount = 21
    static let turnLimit = Double(20) // 20 seconds
    static let turnTick = Double(0.01) // 1/100 second

    // MARK: - Published variables

    @Published var player1 = GGPlayer(displayName: "BLACK", avatarColor: Color.black, homeRow: 0)
    @Published var player2 = GGPlayer(displayName: "WHITE", avatarColor: Color.white, homeRow: GameViewModel.rows - 1)
    @Published var player1Casualties = [[GGRank]]()
    @Published var player2Casualties = [[GGRank]]()
    @Published var moves = [GGMove]()
    @Published var winningPlayer: GGPlayer?
    @Published var activePlayer: GGPlayer?
    @Published var isGameOver = true
    @Published var boardPositions = [[GGBoardPosition]]()
    @Published var selectedBoardPosition: GGBoardPosition?
    @Published var statusText = ""
    @Published var turnText = ""
    @Published var turnProgress = GameViewModel.turnLimit
    @Published var game: FGame?
    
    // MARK: - Public variables

    var onlineModel: OnlineGameViewModel?
    var gameType: GameType
    var gameID: String?
    var player1Positions: [GGBoardPosition]?
    var player2Positions: [GGBoardPosition]?
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Private variables
    
    private var aiTimer: Timer?
    
    // MARK: - Initializers

    init(gameType: GameType,
         gameID: String? = nil,
         player1: FPlayer? = nil,
         player2: FPlayer? = nil,
         player1Positions: [GGBoardPosition]? = nil,
         player2Positions: [GGBoardPosition]? = nil) {
        self.gameType = gameType
        self.gameID = gameID
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
            if let player1 {
                self.player1.id = player1.id
                self.player1.displayName = player1.isLoggedInUser ? "You" : player1.username
            }
            if let player2 {
                self.player2.id = player2.id
                self.player2.displayName = player2.isLoggedInUser ? "You" : player2.username
            }
            
            self.player1Positions = player1Positions
            self.player2Positions = player2Positions
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
            aiTimer = Timer.scheduledTimer(timeInterval: 1,
                                           target: self,
                                           selector: #selector(doAIMoves),
                                           userInfo: nil,
                                           repeats: !isGameOver)
        } else if gameType == .humanVsAI {
            activePlayer = !player1.isBottomPlayer ? player1 : player2
            turnText = "YOUR TURN"
        } else if gameType == .humanVsHuman {
            if let gameID {
                Task {
                    onlineModel = OnlineGameViewModel()
                    await onlineModel?.listenForChanges(in: gameID)
                    
                }
                
                observeOnlineGame()
            }
        }
    }
    
    func quit() {
        aiTimer?.invalidate()
        aiTimer = nil
        
        onlineModel?.quit()
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
        
        if gameType == .humanVsAI {
            activePlayer = !player1.isBottomPlayer ? player2 : player1
        }
        
        checkFlagHomeRun()
        checkGameProgress()
    }

    func doHumanMove(row: Int, column: Int) {
        guard !isGameOver else {
            return
        }
        
        if gameType == .humanVsAI {
            activePlayer = player2
        } else if gameType == .humanVsHuman {
            guard let game,
                  let player = PlayerManager.shared.player,
                  game.activePlayerID == player.id else {
                return
            }
        }
        
        let boardPosition = boardPositions[row][column]

        guard let selectedBoardPosition else {
            addPossibleActions(for: boardPosition)
            self.selectedBoardPosition = boardPositions[row][column]
            return
        }

        // same position selected, deselect
        if (selectedBoardPosition == boardPosition) {
            self.selectedBoardPosition = nil
            clearPossibleActions()
            return
        }

        if !boardPosition.isEmpty() {
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
        
        if gameType == .humanVsAI {
            turnProgress = GameViewModel.turnLimit
            activePlayer = !player1.isBottomPlayer ? player1 : player2
        }
        
        checkFlagHomeRun()
        checkGameProgress()
        
        if gameType == .humanVsAI {
            doAIMove(of: !player1.isBottomPlayer ? player1 : player2)
        } else if gameType == .humanVsHuman {
            onlineModel?.send(lastMove: move)
        }
    }
    
    func checkGameProgress() {
        if isGameOver {
            switch gameType {
            case .aiVsAI:
                statusText = (winningPlayer?.homeRow == 0) ? "BLACK WINS" : "WHITE WINS"
            case .humanVsAI:
                statusText = (winningPlayer?.homeRow == GameViewModel.rows - 1) ? "VICTORY" : "DEFEAT"
                winningPlayer?.homeRow == GameViewModel.rows - 1 ?
                    SoundManager.shared.playVictory() :
                    SoundManager.shared.playDefeat()
            case .humanVsHuman:
                statusText = (winningPlayer?.homeRow == GameViewModel.rows - 1) ? "VICTORY" : "DEFEAT"
                winningPlayer?.homeRow == GameViewModel.rows - 1 ?
                    SoundManager.shared.playVictory() :
                    SoundManager.shared.playDefeat()
            }
            print("Game Over: \(statusText)")

            aiTimer?.invalidate()
            aiTimer = nil
            turnText = ""
        } else {
            switch gameType {
            case .aiVsAI:
                turnText = ""
            case .humanVsAI:
                turnText = activePlayer?.id == player2.id ? "YOUR TURN" : "BLACK'S TURN"
            case .humanVsHuman:
                turnText = game?.activePlayerID == player2.id ? "YOUR TURN" : "OPPONENT'S TURN"
            }
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
    
    func endTurn() {
        if gameType == .humanVsAI {
            turnProgress = GameViewModel.turnLimit
            doAIMove(of: !player1.isBottomPlayer ? player1 : player2)
        } else if gameType == .humanVsHuman {
            
        }
    }
}
 
