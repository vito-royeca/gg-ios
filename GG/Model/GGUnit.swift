//
//  GGUnit.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation

enum GGRank: CaseIterable {
    case general5,
         general4,
         general3,
         general2,
         general1,
         colonel2,
         colonel1,
         major,
         captain,
         lieutenant2,
         lieutenant1,
         sergeant,
         private_,
         spy,
         flag
    
    var description: String {
        switch self {
        case .general5:
            "General of the Army"
        case .general4:
            "General"
        case .general3:
            "Lieutenant General"
        case .general2:
            "Major General"
        case .general1:
            "Brigadier General"
        case .colonel2:
            "Colonel"
        case .colonel1:
            "Lieutenant Colonel"
        case .major:
            "Major"
        case .captain:
            "Captain"
        case .lieutenant2:
            "1st Lieutenant"
        case .lieutenant1:
            "2nd Lieutenant"
        case .sergeant:
            "Sergeant"
        case .private_:
            "Private"
        case .spy:
            "Spy"
        case .flag:
            "Flag"
        }
    }
    
    var iconName: String {
        switch self {
        case .general5:
            "general5"
        case .general4:
            "general4"
        case .general3:
            "general3"
        case .general2:
            "general2"
        case .general1:
            "general1"
        case .colonel2:
            "colonel2"
        case .colonel1:
            "colonel1"
        case .major:
            "major"
        case .captain:
            "captain"
        case .lieutenant2:
            "lieutenant2"
        case .lieutenant1:
            "lieutenant1"
        case .sergeant:
            "sergeant"
        case .private_:
            "private"
        case .spy:
            "spy"
        case .flag:
            "flag"
        }
    }
    
    func challenge(other rank: GGRank) -> GGGameStatus {
        if rank == .flag {
            return GGGameStatus(.win, isGameOver: true)
        }

        guard self != rank else {
            return GGGameStatus(.draw, isGameOver: false)
        }
        
        switch self {
        case .general5:
            switch rank {
            case .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .general4:
            switch rank {
            case .general5, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .general3:
            switch rank {
            case .general5, .general4, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .general2:
            switch rank {
            case .general5, .general4, .general3, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .general1:
            switch rank {
            case .general5, .general4, .general3, .general2, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .colonel2:
            switch rank {
            case .general5, .general4, .general3, .general2, .general1, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .colonel1:
            switch rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .major:
            switch rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .captain:
            switch rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .major, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .lieutenant2:
            switch rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .major, .captain, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .lieutenant1:
            switch rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .major, .captain, .lieutenant2, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .sergeant:
            switch rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .major, .captain, .lieutenant2, .lieutenant1, .spy:
                return GGGameStatus(.loose, isGameOver: false)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .private_:
            switch rank {
            case .spy:
                return GGGameStatus(.win, isGameOver: false)
            case .flag:
                return GGGameStatus(.win, isGameOver: true)
            default:
                return GGGameStatus(.loose, isGameOver: false)
            }
        case .spy:
            switch rank {
            case .private_:
                return GGGameStatus(.loose, isGameOver: false)
            case .flag:
                return GGGameStatus(.win, isGameOver: true)
            default:
                return GGGameStatus(.win, isGameOver: false)
            }
        case .flag:
            return GGGameStatus(.loose, isGameOver: true)
        }
    }
    
    func winsAgainst() -> [GGRank] {
        var results = [GGRank]()
        
        for rank in GGRank.allCases {
            let result = challenge(other: rank)
            if result.challengeResult == .win {
                results.append(rank)
            }
        }
        return results
    }
    
    func losesAgainst() -> [GGRank] {
        var results = [GGRank]()
        
        for rank in GGRank.allCases {
            let result = challenge(other: rank)
            if result.challengeResult == .loose {
                results.append(rank)
            }
        }
        return results
    }
    
    func drawsAgainst() -> [GGRank] {
        var results = [GGRank]()
        
        for rank in GGRank.allCases {
            let result = challenge(other: rank)
            if result.challengeResult == .draw {
                results.append(rank)
            }
        }
        return results
    }
}

enum GGChallengeResult {
    case win, loose, draw
}


struct GGGameStatus {
    let challengeResult: GGChallengeResult
    let isGameOver: Bool
    
    init(_ challengeResult: GGChallengeResult,
         isGameOver: Bool) {
        self.challengeResult = challengeResult
        self.isGameOver = isGameOver
    }
}

class GGUnit: Equatable {
    var id = UUID().uuidString.prefix(8)
    let rank: GGRank
    
    init(rank: GGRank) {
        self.rank = rank
    }

    static func ==(lhs: GGUnit, rhs: GGUnit) -> Bool {
        lhs.id == rhs.id
    }
}
