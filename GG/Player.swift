//
//  Player.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation

class Player: Equatable {
    var id = UUID()
    var isHuman = false

    var general5: GGUnit?
    var general4: GGUnit?
    var general3: GGUnit?
    var general2: GGUnit?
    var general1: GGUnit?
    var colonel2: GGUnit?
    var colonel1: GGUnit?
    var major: GGUnit?
    var captain: GGUnit?
    var lieutenant2: GGUnit?
    var lieutenant1: GGUnit?
    var sergeant: GGUnit?
    var privateA: GGUnit?
    var privateB: GGUnit?
    var privateC: GGUnit?
    var privateD: GGUnit?
    var privateE: GGUnit?
    var privateF: GGUnit?
    var spyA: GGUnit?
    var spyB: GGUnit?
    var flag: GGUnit?
    
    func createUnits() {
        general5 = GGUnit(rank: .general5)
        general4 = GGUnit(rank: .general4)
        general3 = GGUnit(rank: .general3)
        general2 = GGUnit(rank: .general2)
        general1 = GGUnit(rank: .general1)
        colonel2 = GGUnit(rank: .colonel2)
        colonel1 = GGUnit(rank: .colonel1)
        major = GGUnit(rank: .major)
        captain = GGUnit(rank: .captain)
        lieutenant2 = GGUnit(rank: .lieutenant2)
        lieutenant1 = GGUnit(rank: .lieutenant1)
        sergeant = GGUnit(rank: .sergeant)
        privateA = GGUnit(rank: .private_)
        privateB = GGUnit(rank: .private_)
        privateC = GGUnit(rank: .private_)
        privateD = GGUnit(rank: .private_)
        privateE = GGUnit(rank: .private_)
        privateF = GGUnit(rank: .private_)
        spyA = GGUnit(rank: .spy)
        spyB = GGUnit(rank: .spy)
        flag = GGUnit(rank: .flag)
    }
    
    static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
