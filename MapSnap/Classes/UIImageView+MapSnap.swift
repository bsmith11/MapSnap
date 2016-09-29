//
//  UIImageView+MapSnap.swift
//  Pods
//
//  Created by Bradley Smith on 9/28/16.
//
//

import UIKit
import CoreLocation

public extension UIImageView {
    func setMapImageWithCoordinate(coordinate: CLLocationCoordinate2D?, size: CGSize? = nil, placeholderImage: UIImage? = nil) {
        cancelMapImageOperation()
        
        if let placeholderImage = placeholderImage {
            image = placeholderImage
        }
        
        guard let coordinate = coordinate else {
            if placeholderImage == nil {
                image = nil
                setNeedsLayout()
            }
            
            return
        }
        
        let completion = { [weak self] (image: UIImage?, error: NSError?, operationID: NSUUID?) in
            let block = {
                if self?.mapImageOperationUUID != operationID && operationID != nil {
                    return
                }
                
                self?.mapImageOperationUUID = nil
                
                guard error == nil else {
                    return
                }
                
                self?.image = image
                self?.setNeedsLayout()
            }
            
            if NSThread.isMainThread() {
                block()
            }
            else {
                dispatch_async(dispatch_get_main_queue(), block)
            }
        }
        
        mapImageOperationUUID = MapSnapManager.sharedInstance.imageForCoordinate(coordinate, size: size, completion: completion)
    }
    
    func cancelMapImageOperation() {
        guard let operationID = mapImageOperationUUID else {
            return
        }
        
        MapSnapManager.sharedInstance.cancelImageRequestWithID(operationID)
        mapImageOperationUUID = nil
    }
}

// MARK: - Private

private extension UIImageView {
    static var mapImageOperationAssociatedKey = "com.mapSnap.mapImageOperationAssociatedKey"
    
    var mapImageOperationUUID: NSUUID? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.mapImageOperationAssociatedKey) as? NSUUID
        }
        
        set {
            objc_setAssociatedObject(self, &UIImageView.mapImageOperationAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
