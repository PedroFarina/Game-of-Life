//
//  Extensions.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    func pointsAround() -> Set<SCNVector3> {
        var points: Set<SCNVector3> = []
        for x in Int(self.x - MyNode.defaultSearch.x) ... Int(self.x + MyNode.defaultSearch.x) {
            for y in Int(self.y - MyNode.defaultSearch.y) ... Int(self.y + MyNode.defaultSearch.y) {
                for z in Int(self.z - MyNode.defaultSearch.z) ... Int(self.z + MyNode.defaultSearch.z) {
                    let point = SCNVector3(x, y, z)
                    if point != self {
                        points.insert(SCNVector3(x, y, z))
                    }
                }
            }
        }
        return points
    }

    func getCodable() -> NodePosition {
        return NodePosition(x: x, y: y, z: z)
    }

    func toNodePosition() -> NodePosition {
        return NodePosition(x: x, y: y, z: z)
    }

    public static func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    public static func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    public static func *(left: SCNVector3, right: Float) -> SCNVector3 {
        return SCNVector3(left.x * right, left.y * right, left.z * right)
    }
    public static func +(left: SCNVector3, right: Float) -> SCNVector3 {
        return SCNVector3(left.x + right, left.y + right, left.z + right)
    }
}

extension SCNVector3: Equatable {
    public static func ==(lhs: SCNVector3, rsh: SCNVector3) -> Bool {
        return (lhs.x == rsh.x) && (lhs.y == rsh.y) && (lhs.z == rsh.z)
    }
}

extension SCNVector3: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}
