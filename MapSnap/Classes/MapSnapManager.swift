//
//  MapSnapManager.swift
//  Pods
//
//  Created by Bradley Smith on 9/27/16.
//
//

import MapKit
import PINCache

public typealias MapSnapImageCompletion = (UIImage?, Error?, UUID?) -> Void

open class MapSnapManager {
    open static var sharedInstance = MapSnapManager()
    
    open var defaultImageSize = CGSize(width: UIScreen.main.bounds.width, height: 150.0)
    open var cache: MapSnapCache?
    
    fileprivate var pendingOperationIDs = [UUID]()
}

// MARK: - Public

public extension MapSnapManager {
    func cancelImageRequestWithID(_ ID: UUID) {
        guard let index = pendingOperationIDs.index(of: ID) else {
            return
        }
        
        pendingOperationIDs.remove(at: index)
    }
    
    func imageForCoordinate(_ coordinate: CLLocationCoordinate2D, size: CGSize? = nil, completion: MapSnapImageCompletion?) -> UUID? {
        let cache = self.cache ?? PINCache.shared()
        let imageSize = size ?? defaultImageSize
        
        let key = [
            String(describing: coordinate),
            "\(imageSize.width)x\(imageSize.height)"
        ].joined(separator: "-")
        
        if let image = cache.object(forKey: key) as? UIImage {
            completion?(image, nil, nil)
            
            return nil
        }
        else {            
            let operationID = UUID()
            
            let snapshotCompletion = { [weak self] (image: UIImage?, error: Error?) in
                guard let index = self?.pendingOperationIDs.index(of: operationID) else {
                    return
                }
                
                self?.pendingOperationIDs.remove(at: index)
                
                if let image = image {
                    cache.setObject(image, forKey: key)
                }
                
                completion?(image, error, operationID)
            }
            
            pendingOperationIDs.append(operationID)
            
            MKMapSnapshotter.imageForCoordinate(coordinate, size: imageSize, completion: snapshotCompletion)
            
            return operationID
        }
    }
}

extension PINCache: MapSnapCache {}
