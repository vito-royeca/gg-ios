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
    var rating: Double
    
    init(fromPosition: BoardPosition,
         toPosition: BoardPosition,
         rating: Double = 0.0) {
        self.fromPosition = fromPosition
        self.toPosition = toPosition
        self.rating = rating
    }
}
