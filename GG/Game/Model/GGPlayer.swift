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
    
//    // MARK: - Codable
//
//    enum CodingKeys: String, CodingKey {
//        case homeRow
//    }
//
//    required init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id = UUID().uuidString.prefix(8)
//        casualties = [GGRank]()
//        seenPositions = [GGBoardPosition]()
//        homeRow = try container.decode(Int.self, forKey: .homeRow)
//    }
//    
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(homeRow, forKey: .homeRow)
//    }
}

extension GGPlayer: Equatable {
    static func ==(lhs: GGPlayer, rhs: GGPlayer) -> Bool {
        lhs.id == rhs.id
    }
}
