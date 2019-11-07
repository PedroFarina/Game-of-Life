//
//  Position.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 05/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public struct NodePosition: Codable {
    var x: Float?
    var y: Float?
    var z: Float?

    func toSCNVector3() -> SCNVector3? {
        guard let x = x, let y = y, let z = z else {
            return nil
        }
        return SCNVector3(x, y, z)
    }
}
