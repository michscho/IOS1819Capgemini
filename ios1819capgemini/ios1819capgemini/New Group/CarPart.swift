//
//  CarPart.swift
//  ios1819capgemini
//
//  Created by MembrainDev on 19.11.18.
//  Copyright © 2018 TUM LS1. All rights reserved.
//

// MARK: Imports
import Foundation
import ARKit

// MARK: - CarPart
class CarPart: Codable {
    var incidents: [Incident]
    var name: String
    var filePath: URL
    var data: Data?
    var picturePath: URL?
    var pictureData: Data?
    init(incidents: [Incident], filePath: URL) {
        self.incidents = incidents
        self.name = filePath.lastPathComponent
        self.filePath = filePath
        do {
            data = try Data(contentsOf: filePath)
        } catch {
            print("could not load arobject")
        }
    }
    
    convenience init(incidents: [Incident], filePath: URL, previewPicture: URL) {
        self.init(incidents: incidents, filePath: filePath)
        self.picturePath = previewPicture
        do {
            pictureData = try Data(contentsOf: previewPicture)
        } catch {
            print("could not load preview picture")
        }
    }
    
    func reevaluateFilePath() {
        do {
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory = URL(fileURLWithPath: paths[0])
            let path = documentsDirectory.appendingPathComponent(self.name)
            guard let data = data else {
                return
            }
            try data.write(to: path, options: [])
            let name = filePath.lastPathComponent
            filePath = URL(fileURLWithPath: "\(paths[0])/\(name)")
        } catch _ {
            print("Could not save data")
            data = nil
        }
    }
    
    func reevaluatePicturePath() {
        do {
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory = URL(fileURLWithPath: paths[0])
            let pictureName = "\(self.name.dropLast(".arobject".count)).jpg"
            let path = documentsDirectory.appendingPathComponent(pictureName)
            guard let data = pictureData else {
                print("picture data is nil")
                return
            }
            try data.write(to: path, options: [])
            picturePath = URL(fileURLWithPath: "\(paths[0])/\(pictureName)")
        } catch _ {
            print("Could not save picture data")
        }
    }
}
