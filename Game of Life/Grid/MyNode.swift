//
//  PersonNode.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class MyNode: SCNNode {
    private static let defaultVec = SCNVector3(1, 0, 1)
    public weak var gridMap: GridMap?

    public func getInfo() -> ([MyNode], [SCNVector3]) {
        return getInfoIn(MyNode.defaultVec)
    }

    public func getInfoIn(_ range: SCNVector3) -> ([MyNode], [SCNVector3]) {
        guard let gridMap = gridMap else {
            return ([], [])
        }
        let myCoordinate = gridMap.coordinateFor(position: position)
        var nodes: [MyNode] = []
        var vectors: [SCNVector3] = []

        for xDim in Int(myCoordinate.x - range.x) ... Int(myCoordinate.x + range.x) {
            for yDim in Int(myCoordinate.y - range.y) ... Int(myCoordinate.y + range.y) {
                for zDim in Int(myCoordinate.z - range.z) ... Int(myCoordinate.z + range.z) {
                    let checkCoordinate = SCNVector3(xDim, yDim, zDim)
                    if checkCoordinate != myCoordinate {
                        if let neighborNode = gridMap.nodeFor(checkCoordinate) {
                            nodes.append(neighborNode)
                        } else {
                            vectors.append(checkCoordinate)
                        }
                    }
                }
            }
        }
        return (nodes, vectors)
    }

    func getNeighbors() -> [MyNode] {
        return getNeighborsIn(MyNode.defaultVec)
    }

    func getNeighborsIn(_ range: SCNVector3) -> [MyNode] {
        return getInfoIn(range).0
    }

    func getBlank() -> [SCNVector3] {
        return getBlankIn(MyNode.defaultVec)
    }

    func getBlankIn(_ range: SCNVector3) -> [SCNVector3] {
        return getInfoIn(range).1
    }
}
