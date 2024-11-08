//
//  GGPlayer.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation

class GGPlayer {
    var id = UUID().uuidString.prefix(8)
    var casualties = [GGRank]()
    var seenPositions = [GGBoardPosition]()
    var homeRow = 0
    
    init(homeRow: Int) {
        casualties = [GGRank]()
        seenPositions = [GGBoardPosition]()
        self.homeRow = homeRow
    }
    
    var isBottomPlayer: Bool {
        homeRow == GameViewModel.rows - 1
    }
}

extension GGPlayer: Equatable {
    static func ==(lhs: GGPlayer, rhs: GGPlayer) -> Bool {
        lhs.id == rhs.id
    }
}
