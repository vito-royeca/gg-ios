//
//  GGBoardPosition.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import UniformTypeIdentifiers

class GGBoardPosition {
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
