//
//  ARView.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 05/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit
import ARKit

public class ARView: ARSCNView, ARCoachingOverlayViewDelegate{
    weak var controller: GameViewController? {
        didSet {
            setup()
        }
    }

    var myConfiguration = ARWorldTrackingConfiguration()
    func runConfig() {
        guard let controller = controller else {
            return
        }
        myConfiguration.planeDetection = .horizontal
        session.run(myConfiguration)
        session.delegate = controller
    }

    func stopPlaneDetection() {
        myConfiguration.planeDetection = []
        session.run(myConfiguration)
    }

    func setup() {
        guard let controller = controller else {
            return
        }
        runConfig()

        scene = controller.scene
        delegate = controller
        showsStatistics = false
        makeCoaching()
    }

    func makeCoaching() {
        let overlayFrame = superview?.frame ?? frame
        let coachingOverlay = ARCoachingOverlayView(frame: overlayFrame)
        addSubview(coachingOverlay)
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = session
        coachingOverlay.delegate = self
    }

    private var timer: Timer = Timer()
    public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        timer.invalidate()
        controller?.calibrated = false
    }

    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
            self.controller?.calibrated = true
        })
    }

    func castRay(at pos: CGPoint, for alignment: ARRaycastQuery.TargetAlignment = .any) -> [ARRaycastResult] {
        guard let query = raycastQuery(from: pos, allowing: .estimatedPlane, alignment: alignment) else {
            return []
        }
        return session.raycast(query)
    }
}
