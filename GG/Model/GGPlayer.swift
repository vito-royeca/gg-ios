//
//  GGPlayer.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation

class GGPlayer: Equatable {
    var id = UUID()

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
    
    var casualties = [GGUnit]()
    var seenPositions = [BoardPosition]()
    var homeRow = 0
    
    func mobilize(homeRow: Int) {
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
        
        casualties = [GGUnit]()
        seenPositions = [BoardPosition]()
        self.homeRow = homeRow
    }
    
    func destroy(unit: GGUnit) {
        if unit == general5 {
            general5 = nil
            casualties.append(GGUnit(rank: .general5))
        } else if unit == general4 {
            general4 = nil
            casualties.append(GGUnit(rank: .general4))
        } else if unit == general3 {
            general3 = nil
            casualties.append(GGUnit(rank: .general3))
        } else if unit == general2 {
            general2 = nil
            casualties.append(GGUnit(rank: .general2))
        } else if unit == general1 {
            general1 = nil
            casualties.append(GGUnit(rank: .general1))
        } else if unit == colonel2 {
            colonel2 = nil
            casualties.append(GGUnit(rank: .colonel2))
        } else if unit == colonel1 {
            colonel1 = nil
            casualties.append(GGUnit(rank: .colonel1))
        } else if unit == major {
            major = nil
            casualties.append(GGUnit(rank: .major))
        } else if unit == captain {
            captain = nil
            casualties.append(GGUnit(rank: .captain))
        } else if unit == lieutenant2 {
            lieutenant2 = nil
            casualties.append(GGUnit(rank: .lieutenant2))
        } else if unit == lieutenant1 {
            lieutenant1 = nil
            casualties.append(GGUnit(rank: .lieutenant1))
        } else if unit == sergeant {
            sergeant = nil
            casualties.append(GGUnit(rank: .sergeant))
        } else if unit == privateA {
            privateA = nil
            casualties.append(GGUnit(rank: .private_))
        } else if unit == privateB {
            privateB = nil
            casualties.append(GGUnit(rank: .private_))
        } else if unit == privateC {
            privateC = nil
            casualties.append(GGUnit(rank: .private_))
        } else if unit == privateD {
            privateD = nil
            casualties.append(GGUnit(rank: .private_))
        } else if unit == privateE {
            privateE = nil
            casualties.append(GGUnit(rank: .private_))
        } else if unit == privateF {
            privateF = nil
            casualties.append(GGUnit(rank: .private_))
        } else if unit == spyA {
            spyA = nil
            casualties.append(GGUnit(rank: .spy))
        } else if unit == spyB {
            spyB = nil
            casualties.append(GGUnit(rank: .spy))
        } else if unit == flag {
            flag = nil
            casualties.append(GGUnit(rank: .flag))
        }
    }

    var isBottomPlayer: Bool {
        homeRow == GameViewModel.rows - 1
    }

    static func ==(lhs: GGPlayer, rhs: GGPlayer) -> Bool {
        lhs.id == rhs.id
    }
}
