//
//  GGAction.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import Foundation

enum GGAction: Codable {
    case up, left, down, right, fight
    
    var possibleIconName: String {
        switch self {
        case .up:
            "arrow.up.circle.dotted"
        case .left:
            "arrow.left.circle.dotted"
        case .down:
            "arrow.down.circle.dotted"
        case .right:
            "arrow.right.circle.dotted"
        case .fight:
            "figure.fencing.circle"
        }
    }
    
    var lastIconName: String {
        switch self {
        case .up:
            "arrow.up.circle"
        case .left:
            "arrow.left.circle"
        case .down:
            "arrow.down.circle"
        case .right:
            "arrow.right.circle"
        case .fight:
            "figure.fencing.circle"
        }
    }
    
    var smallIconName: String {
        switch self {
        case .up:
            "arrow.up"
        case .left:
            "arrow.left"
        case .down:
            "arrow.down"
        case .right:
            "arrow.right"
        case .fight:
            "figure.fencing"
        }
    }
    
    var opposite: GGAction {
        switch self {
        case .up:
                .down
        case .left:
                .right
        case .down:
                .up
        case .right:
                .left
        case .fight:
                .fight
        }
    }
}
