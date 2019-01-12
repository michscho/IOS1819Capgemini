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

//swiftlint:disable all
// MARK: - Incident
public class Incident: Codable {
    
    let identifier: Int
    let createDate: Date
    
    static var scanID = 0
    
    static var nextScanID: Int {
        scanID += 1
        return scanID
    }

    private(set) var modifiedDate: Date
    private(set) var type: IncidentType
    private(set) var description: String
    private(set) var status: Status
    private(set) var attachments = [AnyAttachment]()

    let coordinate: Coordinate
    var automaticallyDetected = false
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
    
    func editIncidentType(type: IncidentType) {
        self.type = type
    }
    
    // MARK: Private Instance Methods
    private func suggest() -> IncidentType? {
        return nil
    }

    func getCoordinateToVector() -> SCNVector3 {
        var res = SCNVector3.init()
        res.x = coordinate.pointX
        res.y = coordinate.pointY
        res.z = coordinate.pointZ
        return res
    }
    
    func addAttachment(attachment: Attachment) {
        attachments.append(AnyAttachment(attachment))
        attachments.sort {
            $0.attachment.date > $1.attachment.date
        }
        print("\(attachment) added")
    }
    
}

 // MARK: Constants
enum IncidentType: String, Codable {
    case unknown = "Unknown Incident"
    case scratch = "Scratch"
    case dent = "Dent"
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

extension IncidentType: CaseIterable {
    
}
