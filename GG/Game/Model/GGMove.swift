//
//  GGMove.swift
//  GG
//
//  Created by Vito Royeca on 10/26/24.
//

import Foundation

class GGMove {
    let fromPosition: GGBoardPosition
    let toPosition: GGBoardPosition
    var rating: Double
    
    init(fromPosition: GGBoardPosition,
         toPosition: GGBoardPosition,
         rating: Double = 0.0) {
        self.fromPosition = fromPosition
        self.toPosition = toPosition
        self.rating = rating
    }
}
