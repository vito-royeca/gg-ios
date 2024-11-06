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
    let id: String
    var player1ID: String
    var player2ID: String
    var player1Positions: [String]
    var player2Positions: [String]
    var moves: [String]
    var winnerID: String?
}
