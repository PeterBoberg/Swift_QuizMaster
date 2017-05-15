//
// Created by Peter Boberg on 2017-05-11.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import MapKit

class QuizzerMapLocationView: MKAnnotationView {

    private var avatarImageView: AvatarImageView!

    override var image: UIImage? {
        get {
            return self.avatarImageView.image
        }

        set {
            self.avatarImageView.image = newValue
        }
    }
    public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.avatarImageView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.addSubview(self.avatarImageView)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}