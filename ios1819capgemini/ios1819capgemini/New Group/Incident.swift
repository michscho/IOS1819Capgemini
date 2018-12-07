//
//  Incident.swift
//  ios1819capgemini
//
//  Created by MembrainDev on 19.11.18.
//  Copyright © 2018 TUM LS1. All rights reserved.
//

// MARK: Imports
import Foundation
import SceneKit

// MARK: - Incident
public class Incident: Codable {
    
    let identifier: Int
    let createDate: Date

    private(set) var modifiedDate: Date
    private(set) var type: IncidentType
    private(set) var description: String
    private(set) var status: Status
    private(set) var attachments = [Attachment]()
    
    let coordinate: Coordinate
    
    // MARK: Initializers
    init(type: IncidentType, description: String, coordinate: Coordinate) {
        
        identifier = DataHandler.nextIncidentID
        createDate = Date()
        modifiedDate = createDate
        self.type = type
        self.description = description
        status = .open
        self.coordinate = coordinate
    }
    
    // MARK: Instance Methods
    func edit(status: Status, description: String, modifiedDate: Date) {
        self.status = status
        self.description = description
        self.modifiedDate = modifiedDate
    }
    
    // MARK: Private Instance Methods
    private func suggest() -> IncidentType? {
        return nil
    }
    
    func getCoordinateToVector() -> SCNVector3 {
        return SCNVector3(x: coordinate.pointX, y: coordinate.pointY, z: coordinate.pointZ)
    }
}

 // MARK: Constants
enum IncidentType: String, Codable {
    case scratch = "Scratch"
    case dent = "Dent"
    case unknown = "Unknown Incident"
}

enum Status: String, Codable {
    case open
    case progress
    case resolved
}

// MARK: - Extension: Equatable
extension Incident: Equatable {
    public static func == (lhs: Incident, rhs: Incident) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Coordinate: Equatable {
    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.description == rhs.description
    }
}