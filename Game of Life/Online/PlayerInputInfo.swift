//
//  PlayerInputInfo.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 05/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public struct PlayerInputInfo: Codable {
    var nodesPositions: [NodePosition]?
    var name: String?
}
