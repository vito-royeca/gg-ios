//
//  FModel.swift
//  GG
//
//  Created by Vito Royeca on 11/3/24.
//

import Foundation
import FirebaseAuth

struct FPlayer: Codable, Identifiable, Equatable {
    let id: String
    var username: String
    var wins: Int
    var losses: Int
    var draws: Int

    static var emptyPlayer: FPlayer {
        FPlayer(id: "", username: "", wins: 0, losses: 0, draws: 0)
    }
    
    init(id: String,
         username: String,
         wins: Int,
         losses: Int,
         draws: Int) {
        self.id = id
        self.username = username
        self.wins = wins
        self.losses = losses
        self.draws = draws
    }
    
    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id, username, wins, losses, draws
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        wins = try container.decode(Int.self, forKey: .wins)
        losses = try container.decode(Int.self, forKey: .losses)
        draws = try container.decode(Int.self, forKey: .draws)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(wins, forKey: .wins)
        try container.encode(losses, forKey: .losses)
        try container.encode(draws, forKey: .draws)
    }
}

extension FPlayer {
    var isLoggedInUser: Bool {
        guard let user = Auth.auth().currentUser,
              user.uid == id else {
            return false
        }
        
        return true
    }
}

struct FGame: Codable, Identifiable, Equatable {
    var id: String
    var player1ID: String?
    var player2ID: String?
    var player1Positions: [GGBoardPosition]?
    var player2Positions: [GGBoardPosition]?
    var moves: [GGMove]?
    var winnerID: String?
    var activePlayerID: String?
}
