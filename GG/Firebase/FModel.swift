//
//  FModel.swift
//  GG
//
//  Created by Vito Royeca on 11/3/24.
//

import Foundation

struct FPlayer: Codable, Identifiable, Equatable {
    let id: String
    var username: String
    var wins: Int
    var losses: Int
    var draws: Int
    
    static var emptyPlayer: FPlayer {
        FPlayer(id: "", username: "", wins: 0, losses: 0, draws: 0)
    }
}

struct FGame: Codable, Identifiable {
    var id: String
    var player1ID: String?
    var player2ID: String?
    var player1Positions: [GGBoardPosition]?
    var player2Positions: [GGBoardPosition]?
    var moves: [GGMove]?
    var winnerID: String?
    var activePlayerID: String?
}
