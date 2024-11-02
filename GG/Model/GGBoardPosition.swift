//
//  GGBoardPosition.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import UniformTypeIdentifiers

class GGBoardPosition {
    var row: Int
    var column: Int
    var player: GGPlayer?
    var unit: GGUnit?
    var action: GGAction?
    var isLastAction: Bool?

//    enum CodingKeys: String, CodingKey {
//        case row
//        case column
//    }
    
    init (row: Int,
          column: Int,
          player: GGPlayer? = nil,
          unit: GGUnit? = nil,
          action: GGAction? = nil,
          isLastAction: Bool? = nil) {
        self.row = row
        self.column = column
        self.player = player
        self.unit = unit
        self.action = action
        self.isLastAction = isLastAction
    }
    
    init(from board: GGBoardPosition) {
        row = board.row
        column = board.column
        player = board.player
        unit = board.unit
        action = board.action
        isLastAction = board.isLastAction
    }

//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        row = try values.decode(Int.self, forKey: .row)
//        column = try values.decode(Int.self, forKey: .column)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(row, forKey: .row)
//        try container.encode(column, forKey: .column)
//    }
    
    var description: String {
        "\((player?.isBottomPlayer ?? false) ? "White" : "Black").\(unit?.rank ?? .flag)@(\(row),\(column))"
    }
}

extension GGBoardPosition: Equatable {
    static func ==(lhs: GGBoardPosition, rhs: GGBoardPosition) -> Bool {
        lhs.row == rhs.row &&
        lhs.column == rhs.column &&
        lhs.player == rhs.player &&
        lhs.unit == rhs.unit &&
        lhs.action == rhs.action &&
        lhs.isLastAction == rhs.isLastAction
    }
}

//extension BoardPosition: Transferable {
//    static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(for: BoardPosition.self, contentType: .boardPosition)
//    }
//}

//extension BoardPosition: Decodable {
//    convenience init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        row = try values.decode(Int.self, forKey: .row)
//        column = try values.decode(Int.self, forKey: .column)
//
//        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
//        elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
//    }
//}

//extension BoardPosition: Encodable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(row, forKey: .row)
//        try container.encode(column, forKey: .column)
//
//        var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
//        try additionalInfo.encode(elevation, forKey: .elevation)
//    }
//}


extension UTType {
    static var boardPosition = UTType(exportedAs: "com.vitoroyeca.salpakan.boardPosition")
}
