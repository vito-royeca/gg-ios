//
//  GGUnit.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import Foundation

enum GGRank {
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
}

enum GGChallengeResult {
    case win,
         loose,
         draw,
         gameOver
}

class GGUnit {
    let rank: GGRank
    
    init(rank: GGRank) {
        self.rank = rank
    }
    
    var description: String {
        switch rank {
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
        switch rank {
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
    
    func challenge(other unit: GGUnit) -> GGChallengeResult {
        guard self.rank != unit.rank else {
            return .draw
        }
        
        guard unit.rank != .spy else {
            return .loose
        }
        
        switch rank {
        case .general5:
            return .win
        case .general4:
            switch unit.rank {
            case .general5:
                return .loose
            default:
                return .win
            }
        case .general3:
            switch unit.rank {
            case .general5, .general4:
                return .loose
            default:
                return .win
            }
        case .general2:
            switch unit.rank {
            case .general5, .general4, .general3:
                return .loose
            default:
                return .win
            }
        case .general1:
            switch unit.rank {
            case .general5, .general4, .general3, .general2:
                return .loose
            default:
                return .win
            }
        case .colonel2:
            switch unit.rank {
            case .general5, .general4, .general3, .general2, .general1:
                return .loose
            default:
                return .win
            }
        case .colonel1:
            switch unit.rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2:
                return .loose
            default:
                return .win
            }
        case .major:
            switch unit.rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1:
                return .loose
            default:
                return .win
            }
        case .captain:
            switch unit.rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .major:
                return .loose
            default:
                return .win
            }
        case .lieutenant2:
            switch unit.rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .major, .captain:
                return .loose
            default:
                return .win
            }
        case .lieutenant1:
            switch unit.rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .major, .captain, .lieutenant2:
                return .loose
            default:
                return .win
            }
        case .sergeant:
            switch unit.rank {
            case .general5, .general4, .general3, .general2, .general1, .colonel2, .colonel1, .major, .captain, .lieutenant2, .lieutenant1:
                return .loose
            default:
                return .win
            }
        case .private_:
            switch unit.rank {
            case .spy:
                return .win
            case .flag:
                return .gameOver
            default:
                return .loose
            }
        case .spy:
            switch unit.rank {
            case .private_:
                return .loose
            case .flag:
                return .gameOver
            default:
                return .win
            }
        case .flag:
            switch unit.rank {
            case .flag:
                return .gameOver
            default:
                return .loose
            }
        }
    }
    
}

