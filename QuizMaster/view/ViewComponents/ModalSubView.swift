//
// Created by Peter Boberg on 2017-05-22.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ModalSubView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()

    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }


    private func configure() {
        self.backgroundColor = UIColor(colorLiteralRed: 12 / 255, green: 54 / 255, blue: 80 / 255, alpha: 1.0)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
    }


}
