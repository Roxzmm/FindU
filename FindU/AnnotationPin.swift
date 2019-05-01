//
//  AnnotationPin.swift
//  FindU
//
//  Created by 张景 on 2019/4/30.
//  Copyright © 2019 Jing. All rights reserved.
//

import MapKit

class AnnotationPin : NSObject, MKAnnotation{
    var title:String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String,subtitle: String,coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

