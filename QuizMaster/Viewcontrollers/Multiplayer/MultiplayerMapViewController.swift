//
//  MultiplayerMapViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-10.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class MultiplayerMapViewController: UIViewController {

    var quizMatch: QuizMatch!
    var progressViewController: ProgressIndicatorViewController!
    let dispatchGroup: DispatchGroup = DispatchGroup()

    @IBOutlet weak var mapView: MKMapView!

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        progressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProgressIndicatorViewController") as! ProgressIndicatorViewController
        mapView.delegate = self
        downloadData()

    }

    // MARK: UI Methods
    @IBAction func back(_ sender: CircularButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: Private methods

extension MultiplayerMapViewController {

    fileprivate func downloadData() {
        print("Downloading location objects")
        ParseDbManager.shared.bgFindQuizzerLocationsFor(quizMatch: quizMatch, completion: {
            [unowned self] (locations, error) in

            print("Returned from dowloading location objects")
            guard error == nil else {
                // TODO Better error handling
                print(error)
                return
            }

            print("No errors")

            var quizzerAnnotaions = [QuizzerAnnotation]()

            if let locations = locations {
                print("Got location data")

                for locationObject in locations {
                    self.dispatchGroup.enter()
                    print("Downloading image for \(locationObject.quizzer?.username)")
                    ParseDbManager.shared.bgDownloadAvatarPictureFor(quizzer: locationObject.quizzer!, completion: {
                        [unowned self] (image, error) in
                        print("Returned from downloading image for \(locationObject.quizzer?.username)")
                        self.dispatchGroup.leave()
                        guard error == nil else {
                            print(error)
                            return
                        }

                        let coordinate = CLLocationCoordinate2D(latitude: locationObject.location!.latitude, longitude: locationObject.location!.longitude)
                        let quizzerAnnnotation = QuizzerAnnotation(user: locationObject.quizzer!.username!, image: image, coordinate: coordinate)
                        quizzerAnnotaions.append(quizzerAnnnotation)

                    })
                }

                self.dispatchGroup.notify(queue: .main, execute: {
                    print("Notifying om main queue")
//                    self.mapView.addAnnotations(quizzerAnnotaions)
                    self.mapView.showAnnotations(quizzerAnnotaions, animated: true)
                })

            } else {
                print("locationobjects vas nil, or could not cast to QuizzerLocation")
            }
        })

    }
}

// MARK: MapviewDelegate

extension MultiplayerMapViewController: MKMapViewDelegate {


    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is QuizzerAnnotation {
            let annotation = annotation as! QuizzerAnnotation
            var quizzerMapLocationView: QuizzerMapLocationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "QuizzerMapLocationView") as? QuizzerMapLocationView

            if quizzerMapLocationView == nil {
                // Make new AnnotationView
                quizzerMapLocationView = QuizzerMapLocationView(annotation: annotation, reuseIdentifier: "QuizzerMapLocationView")
            }

            quizzerMapLocationView?.annotation = annotation
            quizzerMapLocationView?.image = annotation.image
            return quizzerMapLocationView

        }
        return nil
    }
}








