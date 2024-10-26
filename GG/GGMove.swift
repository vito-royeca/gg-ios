//
//  GGMove.swift
//  GG
//
//  Created by Vito Royeca on 10/26/24.
//

import Foundation

class GGMove {
    let fromPosition: BoardPosition
    let toPosition: BoardPosition
    let rating: Double
    
    init(fromPosition: BoardPosition,
         toPosition: BoardPosition,
         rating: Double) {
        self.fromPosition = fromPosition
        self.toPosition = toPosition
        self.rating = rating
    }
}
