//
//  ModelViewController.swift
//  ios1819capgemini
//
//  Created by Michael Schott on 11.01.19.
//  Copyright © 2019 TUM LS1. All rights reserved.
//

import Foundation
import UIKit
//swiftlint:disable all
class ModelViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static var objectName: String?
    
    @IBAction private func exploreButton(_ sender: Any) {
        creatingNodePossible = true
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction private func reportButton(_ sender: Any) {
        creatingNodePossible = true
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // MARK: Overriddent instance methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = ModelViewController.objectName {
            DataHandler.objectsToIncidents[name] = DataHandler.incidents
        }
        // add blurred subvie w
        print("view did load")
        print("dictionary before reset: \(DataHandler.objectsToIncidents)")
        ARViewController.resetButtonPressed = true
        print("dictionary after reset: \(DataHandler.objectsToIncidents)")
//        if let name = ModelViewController.objectName {
//            print("mvc name: \(name)")
//            DataHandler.objectsToIncidents[name] = DataHandler.incidents
//            ModelViewController.objectName = nil
//            DataHandler.incidents = []
//            print("datahandler objets to incidents [name] count \(DataHandler.objectsToIncidents[name]?.count)")
//            print("DataHandler.incidents : \(DataHandler.incidents)") //nil
//        }
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = UIScreen.main.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationController?.view.addSubview(blurView)
        self.navigationController?.view.sendSubviewToBack(blurView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        creatingNodePossible = false
    }
    
    let reuseIdentifier = "modelCell" 
    
    // MARK: - UICollectionViewDataSource protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataHandler.objectsToIncidents.count
    }
    
    //swiftlint:disable all
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sortedDictonary = Array(DataHandler.objectsToIncidents.keys).sorted()
        
        let name = sortedDictonary[indexPath.item]
        let incidents = DataHandler.objectsToIncidents[name]
        print("name \(name)")
        print("incidents : \(incidents)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ARModelsCollectionViewCell
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(name).jpg")
            let image    = UIImage(contentsOfFile: imageURL.path)
            cell.modelImage.image = image
            cell.modelNameLabel.text = name
            cell.openNumber.text = String(incidents?.filter{$0.status == .open}.count ?? 0)
            cell.progessNumber.text = String(incidents?.filter{$0.status == .progress}.count ?? 0)
            cell.resolvedNumber.text = String(incidents?.filter{$0.status == .resolved}.count ?? 0)
            }
        
        return cell
    }
    

    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // only viewing
    }
}
