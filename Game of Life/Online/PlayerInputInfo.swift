//
//  PlayerInputInfo.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 05/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

public struct PlayerInputInfo: Codable {
    var _id: String?
    var name: String?
    var nodesPositions: [NodePosition]?
}
