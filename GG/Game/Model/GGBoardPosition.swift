//
//  GGBoardPosition.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import UniformTypeIdentifiers

class GGBoardPosition: Codable {
    var row: Int
    var column: Int
    var player: GGPlayer?
    var rank: GGRank?
    var action: GGAction?
    var isLastAction: Bool?

    init (row: Int,
          column: Int,
          player: GGPlayer? = nil,
          rank: GGRank? = nil,
          action: GGAction? = nil,
          isLastAction: Bool? = nil) {
        self.row = row
        self.column = column
        self.player = player
        self.rank = rank
        self.action = action
        self.isLastAction = isLastAction
    }
    
    init(from board: GGBoardPosition) {
        row = board.row
        column = board.column
        player = board.player
        rank = board.rank
        action = board.action
        isLastAction = board.isLastAction
    }

    var description: String {
        "\((player?.isBottomPlayer ?? false) ? "White" : "Black").\(rank ?? .flag)@(\(row),\(column))"
    }
    
    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case row, column, rank, action, isLastAction
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        row = try container.decode(Int.self, forKey: .row)
        column = try container.decode(Int.self, forKey: .column)
        rank = try container.decodeIfPresent(GGRank.self, forKey: .rank)
        action = try container.decodeIfPresent(GGAction.self, forKey: .action)
        isLastAction = try container.decodeIfPresent(Bool.self, forKey: .isLastAction)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(row, forKey: .row)
        try container.encode(column, forKey: .column)
        try container.encode(rank, forKey: .rank)
        try container.encode(action, forKey: .action)
        try container.encode(isLastAction, forKey: .isLastAction)
    }
}

extension GGBoardPosition: Equatable {
    static func ==(lhs: GGBoardPosition, rhs: GGBoardPosition) -> Bool {
        lhs.row == rhs.row &&
        lhs.column == rhs.column &&
        lhs.player == rhs.player &&
        lhs.rank == rhs.rank &&
        lhs.action == rhs.action &&
        lhs.isLastAction == rhs.isLastAction
    }
}

extension UTType {
    static var boardPosition = UTType(exportedAs: "com.vitoroyeca.salpakan.boardPosition")
}
