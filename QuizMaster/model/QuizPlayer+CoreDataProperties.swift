//
//  QuizPlayer+CoreDataProperties.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-19.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import CoreData


extension QuizPlayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizPlayer> {
        return NSFetchRequest<QuizPlayer>(entityName: "QuizPlayer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var avatar: NSData?
    @NSManaged public var quixGameResult: NSSet?

}

// MARK: Generated accessors for quixGameResult
extension QuizPlayer {

    @objc(addQuixGameResultObject:)
    @NSManaged public func addToQuixGameResult(_ value: QuizGameResult)

    @objc(removeQuixGameResultObject:)
    @NSManaged public func removeFromQuixGameResult(_ value: QuizGameResult)

    @objc(addQuixGameResult:)
    @NSManaged public func addToQuixGameResult(_ values: NSSet)

    @objc(removeQuixGameResult:)
    @NSManaged public func removeFromQuixGameResult(_ values: NSSet)

}
