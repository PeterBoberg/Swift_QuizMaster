//
// Created by Kung Peter on 2017-04-21.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AvatarImageView: UIImageView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()

    }

    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        configure()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }


    private func configure() {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor(red: 0 / 255, green: 115 / 255, blue: 153 / 255, alpha: 1.0).cgColor
        self.clipsToBounds = true
    }

}
