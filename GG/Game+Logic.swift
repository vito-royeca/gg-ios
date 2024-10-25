//
//  Game+Logic.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension Game {
    func doAIMove() {
        // 1) check if flag is in danger
        // 2) if flag is in danger, destroy flag's attacker
        // 3) if flag is in danger, retreat flag
        // 4) calculate highest move
        // 5) execute highest move
        
    }
    
    func boardPosition(of player: GGPlayer, rank: GGRank) -> [BoardPosition] {
        return []
    }
    
    func boardPosition(of unit: GGUnit) -> BoardPosition {
        return BoardPosition(row: 0, column: 0)
    }
}
