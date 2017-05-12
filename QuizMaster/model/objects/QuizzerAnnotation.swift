//
// Created by Peter Boberg on 2017-05-11.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import MapKit

class QuizzerAnnotation: NSObject, MKAnnotation {

    var user: String
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D

    init(user: String, image: UIImage?, coordinate: CLLocationCoordinate2D) {
        self.user = user
        self.image = image
        self.coordinate = coordinate
    }
}

