/*
 Copyright © 2018 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
Abstract:
A generalized interactive visualization of a 3D point cloud.
*/

import SceneKit

// This is a protocol that should be implemented by all point cloud classes (ScannedPointCloud, DetectedPointCloud).
protocol PointCloud {
    func createVisualization(for points: [float3], color: UIColor, size: CGFloat) -> SCNGeometry?
}

// All classes implementing the PointCloud protocol can benefit from this createVisualization implementation.
extension PointCloud {
    func createVisualization(for points: [float3], color: UIColor, size: CGFloat) -> SCNGeometry? {
        guard !points.isEmpty else {
            return nil }
        
        let stride = MemoryLayout<float3>.size
        let pointData = Data(bytes: points, count: stride * points.count)
        
        // Create geometry source
        let source = SCNGeometrySource(data: pointData,
                                       semantic: SCNGeometrySource.Semantic.vertex,
                                       vectorCount: points.count,
                                       usesFloatComponents: true,
                                       componentsPerVector: 3,
                                       bytesPerComponent: MemoryLayout<Float>.size,
                                       dataOffset: 0,
                                       dataStride: stride)
        
        // Create geometry element
        let element = SCNGeometryElement(data: nil, primitiveType: .point, primitiveCount: points.count, bytesPerIndex: 0)
        element.pointSize = 0.001
        element.minimumPointScreenSpaceRadius = size
        element.maximumPointScreenSpaceRadius = size
        
        let pointsGeometry = SCNGeometry(sources: [source], elements: [element])
        pointsGeometry.materials = [SCNMaterial.material(withDiffuse: color)]
        
        return pointsGeometry
    }
}