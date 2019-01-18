//
//  ARViewControllerSessionExtension.swift
//  ios1819capgemini
//
//  Created by Minh Tran on 14.01.19.
//  Copyright © 2019 TUM LS1. All rights reserved.
//

import Foundation
import ARKit

extension ARViewController {
    
    func updateIncidents() {
        
        if !ARViewController.objectDetected {
            return
        }
        incidentEditted()
        for incident in DataHandler.incidents {
            if incidentHasNotBeenPlaced(incident: incident) {
                guard let detectedObjectNode = detectedObjectNode else {
                    print("detected object node not initialized in updateIncidents() ")
                    return
                }
                let coordinateRelativeObject = detectedObjectNode.convertPosition(incident.getCoordinateToVector(), to: nil)
                add3DPin(vectorCoordinate: coordinateRelativeObject, identifier: "\(incident.identifier)")
            }
        }
    }
    
    func checkConnection () {
        if !multipeerSession.connectedPeers.isEmpty {
            ARViewController.connectedToPeer = true
            let peerNames = multipeerSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
            connectionLabel.text = "Connected with \(peerNames)"
        }
    }
    
    func checkReset() {
        if !ARViewController.resetButtonPressed {
            return
        } else {
            reset()
            ARViewController.resetButtonPressed = false
        }
    }
    
    func checkSendIncidents() {
        if !ARViewController.sendIncidentButtonPressed {
            return
        } else {
            sendIncidents()
            ARViewController.resetButtonPressed = false
        }
    }
    func refreshNodes() {
        
        for node in nodes {
            guard let name = node.name else {
                return
            }
            if DataHandler.incidents.isEmpty {
                do {
                    let data = try JSONEncoder().encode(DataHandler.incidents)
                    self.multipeerSession.sendToAllPeers(data)
                } catch {
                    print("sending incidents array failed (refreshNodes DataHandler.incidents.isEmpty)")
                }
            }
            if DataHandler.incident(withId: name) == nil {
                self.scene.rootNode.childNode(withName: name, recursively: false)?.removeFromParentNode()
                deleteNode(identifier: name)
                do {
                    let data = try JSONEncoder().encode(DataHandler.incidents)
                    self.multipeerSession.sendToAllPeers(data)
                } catch {
                    print("sending incidents array failed (refreshNodes DataHandler.incident(withId: name) == nil")
                }
            }
        }
    }
    
    func loadCustomScans() {
        
        let fileManager = FileManager.default
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for file in fileURLs {
                if file.lastPathComponent.hasSuffix(".arobject") {
                    let arRefereceObject = try ARReferenceObject(archiveURL: file)
                    detectionObjects.insert(arRefereceObject)
                }
            }
        } catch {
            print("Error loading custom scans")
        }
    }
    
    func checkSettings() {
        // Check settings
        if UserDefaults.standard.bool(forKey: "enable_boundingboxes") {
            sceneView.debugOptions = [.showFeaturePoints, .showBoundingBoxes]
        } else if UserDefaults.standard.bool(forKey: "enable_featurepoints") {
            sceneView.debugOptions = [.showFeaturePoints]
        } else {
            sceneView.debugOptions = []
        }
        if UserDefaults.standard.bool(forKey: "enable_detection") && detectedObjectNode != nil {
            isDetecting = true
            setupBoxes()
        } else {
            hideBoxes()
            isDetecting = false
        }
    }
    
    func updateSession(for trackingState: ARCamera.TrackingState, incident: Incident?) {
        
        checkSettings()
        checkConnection()
        checkReset()
        checkSendIncidents()
        updateIncidents()
        refreshNodes()
        updatePinColour()
        setDescriptionLabel()
        setNavigationArrows(for: trackingState, incident: incident)
        
    }
    
}
