//
//  GridCoordinate.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class GridMap {
    let tileDimension: SCNVector3
    var occupieds: [String: MyNode] = [:]

    init(tileDimension: SCNVector3) {
        self.tileDimension = tileDimension
    }

    func positionFor(coordinate: SCNVector3) -> SCNVector3 {
        return SCNVector3(tileDimension.x * floor(coordinate.x), tileDimension.y * floor(coordinate.y), tileDimension.z * floor(coordinate.z))
    }

    func coordinateFor(position: SCNVector3) -> SCNVector3 {
        return SCNVector3(floor(position.x / tileDimension.x), floor(position.y / tileDimension.y), floor(position.z / tileDimension.z))
    }

    func register(_ object: MyNode, coordinate: SCNVector3) {
        object.gridMap = self
        occupieds[vecToString(coordinate)] = object
    }

    func remove(_ coordinate: SCNVector3) {
        if let node = nodeFor(coordinate) {
            self.remove(node)
        }
    }

    func remove(_ object: MyNode) {
        object.gridMap = nil
        let coordinate = coordinateFor(position: object.position)
        occupieds[vecToString(coordinate)] = nil
    }

    func checkOccupied(_ coordinate:SCNVector3) -> Bool {
        return occupieds[vecToString(coordinate)] != nil
    }

    func nodeFor(_ coordinate: SCNVector3) -> MyNode? {
        return occupieds[vecToString(coordinate)]
    }

    func nodesFor(_ coordinates: [SCNVector3]) -> [MyNode] {
        var nodes: [MyNode] = []
        for coordinate in coordinates {
            if let node = nodeFor(coordinate) {
                nodes.append(node)
            }
        }
        return nodes
    }

    func nodesFor(_ coordinates: Set<SCNVector3>) -> Set<MyNode> {
        var nodes: Set<MyNode> = []
        for coordinate in coordinates {
            if let node = nodeFor(coordinate) {
                nodes.insert(node)
            }
        }
        return nodes
    }

    private func vecToString(_ vec: SCNVector3) -> String {
        return "\(vec.x)\(vec.y)\(vec.z)"
    }
}
