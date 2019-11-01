//
//  GameViewController.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    private var scene: SCNScene = {
        guard let scene = SCNScene(named: "art.scnassets/GameScene.scn") else {
            fatalError("Não foi possível inicializar a cena")
        }
        return scene
    }()
    private lazy var sceneView: SCNView = {
        guard let view = self.view as? SCNView else {
            fatalError("Não foi possível inicializar a view")
        }
        view.delegate = self
        view.scene = scene
        view.allowsCameraControl = true
        view.showsStatistics = true
        return view
    }()
    
    private lazy var gridController: LifeGridController = LifeGridController(scene: scene, sceneView: sceneView, tileDimension: SCNVector3(2, 1, 2))

    var cameraNode: SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        return cameraNode
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add a camera to the scene
        scene.rootNode.addChildNode(cameraNode)
        for i in 0...8000 {
            let life = LifeNode()
            gridController.addAt(life, coordinate: SCNVector3(-i, 0, 0))
        }

        // place the camera
        cameraNode.position = SCNVector3(x: -2, y: 9, z: 20)
        cameraNode.eulerAngles = SCNVector3(-0.5, 0, 0)
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    func makeNewGeneration() {
        gridController.nextGeneration()
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        makeNewGeneration()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
