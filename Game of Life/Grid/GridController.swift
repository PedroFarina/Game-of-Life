//
//  GridManager.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class GridController {
    private let scene: SCNScene
    private let sceneView: SCNView
    private var gridMap: GridMap

    init(scene: SCNScene, sceneView: SCNView, tileDimension: SCNVector3) {
        self.scene = scene
        self.sceneView = sceneView
        gridMap = GridMap(tileDimension: tileDimension)
    }

    public func addAt(_ object: MyNode, coordinate: SCNVector3) {
        if !gridMap.checkOccupied(coordinate) {
            object.position = gridMap.positionFor(coordinate: coordinate)
            gridMap.register(object, coordinate: coordinate)
            scene.rootNode.addChildNode(object)
        }
    }

    public func removeAt(_ coordinate: SCNVector3) {
        if let object = gridMap.nodeFor(coordinate) {
            object.removeFromParentNode()
            gridMap.remove(coordinate)
        }
    }

    public func remove(_ object: MyNode) {
        object.removeFromParentNode()
        gridMap.remove(object)
    }
}
