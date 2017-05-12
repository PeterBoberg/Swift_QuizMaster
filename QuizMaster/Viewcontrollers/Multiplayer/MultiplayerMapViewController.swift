//
//  MultiplayerMapViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-10.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit
import MapKit

class MultiplayerMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        let coord = CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)
        let someAnnotation = QuizzerAnnotation(user: "pebo0602", image: UIImage(named: "paperPlane"), coordinate: coord)

        mapView.addAnnotation(someAnnotation)
    }
}

// MARK: MapviewDelegate

extension MultiplayerMapViewController: MKMapViewDelegate {


    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print(annotation.title)
        if annotation is QuizzerAnnotation {
            let annotation = annotation as! QuizzerAnnotation
            var quizzerMapLocationView: QuizzerMapLocationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "QuizzerMapLocationView") as? QuizzerMapLocationView

            if quizzerMapLocationView == nil {
                // MAke new AnnotationView
                quizzerMapLocationView = QuizzerMapLocationView(annotation: annotation, reuseIdentifier: "QuizzerMapLocationView")
            }

            quizzerMapLocationView?.annotation = annotation
            quizzerMapLocationView?.image = annotation.image
            return quizzerMapLocationView

        }
        return nil
    }
}








