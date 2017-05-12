//
// Created by Peter Boberg on 2017-05-12.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreLocation

class QuizLocationManager: CLLocationManager {

    static let shared = QuizLocationManager()

    override private init() {
        super.init()
        self.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.activityType = .other
    }
}
