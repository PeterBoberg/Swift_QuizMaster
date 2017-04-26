//
// Created by Kung Peter on 2017-04-23.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import Parse


class Quizzer: PFUser {


    @NSManaged var avatarImage: PFFile?
    @NSManaged var friends: [Quizzer]?

}
