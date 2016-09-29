//
//  MapSnapManager.swift
//  Pods
//
//  Created by Bradley Smith on 9/27/16.
//
//

import MapKit
import PINCache

public typealias MapSnapImageCompletion = (UIImage?, NSError?, NSUUID?) -> Void

public class MapSnapManager {
    public static var sharedInstance = MapSnapManager()
    
    public var defaultImageSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 150.0)
    public var cache: MapSnapCache?
    
    private var pendingOperationIDs = [NSUUID]()
}

// MARK: - Public

public extension MapSnapManager {
    func cancelImageRequestWithID(ID: NSUUID) {
        guard let index = pendingOperationIDs.indexOf(ID) else {
            return
        }
        
        pendingOperationIDs.removeAtIndex(index)
    }
    
    func imageForCoordinate(coordinate: CLLocationCoordinate2D, size: CGSize? = nil, completion: MapSnapImageCompletion?) -> NSUUID? {
        let cache = self.cache ?? PINCache.sharedCache()
        let imageSize = size ?? defaultImageSize
        
        let key = [
            String(coordinate),
            "\(imageSize.width)x\(imageSize.height)"
        ].joinWithSeparator("-")
        
        if let image = cache.objectForKey(key) as? UIImage {
            completion?(image, nil, nil)
            
            return nil
        }
        else {            
            let operationID = NSUUID()
            
            let snapshotCompletion = { [weak self] (image: UIImage?, error: NSError?) in
                guard let index = self?.pendingOperationIDs.indexOf(operationID) else {
                    return
                }
                
                self?.pendingOperationIDs.removeAtIndex(index)
                
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
