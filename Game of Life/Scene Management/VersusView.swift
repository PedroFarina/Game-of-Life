//
//  VersusView.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 07/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit

public class VersusView: SCNView, SCNSceneRendererDelegate {
    private var versusScene: SCNScene = {
        guard let scene = SCNScene(named: "art.scnassets/Versus Scene.scn") else {
            fatalError("Não foi possível criar a cena versus")
        }
        return scene
    }()
    let timeToLoop = 0.5
    lazy var currentTime = timeToLoop
    private lazy var gridController = LifeGridController(scene: versusScene, sceneView: self, tileDimension: SCNVector3(0.1, 0.1, 0.1))
    public func start() {
        self.scene = versusScene
        let cameraNode = SCNNode()
        delegate = self
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 1.5, z: 2)
        cameraNode.eulerAngles = SCNVector3(-88.4, 0, 0)
        versusScene.rootNode.addChildNode(cameraNode)
        makeLights()
        self.allowsCameraControl = true
        for i in -1...1 {
            let life = LifeNodePool.getLife()
            gridController.addAt(life, coordinate: SCNVector3(i, 0, 0))
        }
    }

    func makeLights() {
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 100, z: 10)
        versusScene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        versusScene.rootNode.addChildNode(ambientLightNode)
    }

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > currentTime {
            gridController.nextGeneration()
            currentTime = time + timeToLoop
        }
    }
}
