//
//  MKMapSnapshotter+MapSnap.swift
//  Pods
//
//  Created by Bradley Smith on 9/27/16.
//
//

import MapKit

public typealias MapSnapshotterCompletion = (UIImage?, NSError?) -> Void

public extension MKMapSnapshotter {
    static func imageForCoordinate(coordinate: CLLocationCoordinate2D, size: CGSize, completion: MapSnapshotterCompletion?) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let options = MKMapSnapshotOptions()
        options.region = region
        options.size = size
        
        let snapshotter = MKMapSnapshotter(options: options)
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        snapshotter.startWithQueue(queue, completionHandler: { (snapshot: MKMapSnapshot?, error: NSError?) in
            guard let snapshot = snapshot else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(nil, error)
                })
                
                return
            }
            
            let image = snapshot.image
            let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.drawAtPoint(.zero)
            
            var point = snapshot.pointForCoordinate(coordinate)
            let visibleRect = CGRect(origin: .zero, size: image.size)
            
            if visibleRect.contains(point) {
                point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2.0)
                point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2.0)
                pin.image?.drawAtPoint(point)
            }
            
            let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            dispatch_async(dispatch_get_main_queue(), {
                completion?(compositeImage, nil)
            })
        })
    }
}
