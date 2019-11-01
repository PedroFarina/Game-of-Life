//
//  LifeNode.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class LifeNode: MyNode, GridListener {
    private static let defaultDimensions: SCNVector3 =  SCNVector3(1, 1, 1)

    override init() {
        super.init()
        let myGeometry = SCNBox(
            width: CGFloat(LifeNode.defaultDimensions.x),
            height: CGFloat(LifeNode.defaultDimensions.y),
            length: CGFloat(LifeNode.defaultDimensions.z),
            chamferRadius: 0)

        myGeometry.firstMaterial?.diffuse.contents = UIColor.random()

        geometry = myGeometry
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }

    public func setColor(_ color: UIColor) {
        geometry?.firstMaterial?.diffuse.contents = color
    }
    
    var rules:[([MyNode]) -> Bool] = [ Rules.overPopulationRule, Rules.solitudeRule ]
    var willLive: Bool = true

    func getNextGenerationSpots(controller: LifeGridController) -> Set<SCNVector3> {
        let info = getInfo()

        for rule in rules {
            willLive = willLive && rule(info.0)
            if !willLive {
                controller.register(self)
                break
            }
        }

        var newSpawns: Set<SCNVector3> = []
        for blank in info.1 {
            if !newSpawns.contains(blank) &&
                gridMap?.nodesFor(blank.pointsAround()).count ?? 0 >= 3 {
                newSpawns.insert(blank)
            }
        }

        return newSpawns
    }

    public func execute(forGrid grid: LifeGridController) {
        if !willLive {
            grid.remove(self)
        }
    }
}
