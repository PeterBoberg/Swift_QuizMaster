//: Playground - noun: a place where people can play



import UIKit
import Parse
import Alamofire
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let config = ParseClientConfiguration(block: {
    (conf) in
    conf.applicationId = "74991f277f94da6fcf624f1c2978232dcb1319f4"
    conf.clientKey = "1cac94a5b15fd2408e8e2107ab8613fe214be8a9"
    conf.server = "http://ec2-52-29-42-145.eu-central-1.compute.amazonaws.com:80/parse/"
})



Parse.initialize(with: config)



// MARK: extension Array

extension Array {
    
    mutating func shuffleInPlace() {
        
        guard self.count > 2 else {
            return
        }
        
        for index in 0...self.count - 1 {
            let rand1 = Int(arc4random_uniform(UInt32(self.count)))
            let rand2 = Int(arc4random_uniform(UInt32(self.count)))
            let tempItem = self[rand1]
            self[rand1] = self[rand2]
            self[rand2] = tempItem
        }
        
    }
}

// MARK: extension String

extension String {
    func convertHtmlSymbols() throws -> String? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        
        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
}

// MARK: extension NSSet

extension NSSet {
    
    
}



struct Constants {
    
    struct URL {
        static let BaseUrl = "https://opentdb.com/api.php"
        
        static let Scheme = "https"
        static let Host = "opentdb.com"
        static let Path = "/api.php"
    }
    
    struct QParamsKeys {
        static let Amount = "amount"
        static let Category = "category"
        static let Difficulty = "difficulty"
        static let AnswerType = "type"
        static let token = "token"
    }
    
    
    struct QParamValues {
        
        struct Categories {
            static let Mythology = "20"
            static let Geography = "22"
            static let ScienceNature = "17"
            static let History = "23"
            static let Sports = "21"
            static let Film = "11"
            static let Animals = "27"
            static let GeneralKnowledge = "9"
        }
        
        struct Difficulty {
            static let Easy = "easy"
            static let Medium = "medium"
            static let Hard = "hard"
        }
        
        struct AnswerType {
            static let Multiple = "multiple"
            static let TrueFalse = "boolean"
        }
        
        struct Token {
            static let token = "ac7ed02c562277854d17b1516f38e570fbb0b22aa36ec9c2231e851715108567"
        }
        
    }
    
}

enum QuizError: Error {
    
    case NetworkError(String)
    case ParseError(String)
    case UrlError(String)
    
}


enum Category : String {
    
    case mythology = "Mythology"
    case geography = "Geography"
    case scienceNature = "Science & Nature"
    case history = "History"
    case sports = "Sports"
    case film = "Film"
    case animals = "Animals"
    case generalKnowledge = "General Knowledge"
}


enum Difficulty: String {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
}




struct QuizQuestion {
    
    let category: String?
    let difficulty: String?
    let type: String?
    let question: String?
    let correctAnswer: String?
    let incorrectAnswers: [String]?
    
    init(category: String?,
         difficulty: String?,
         type: String?,
         question: String?,
         correctAnswer: String?,
         incorrectAnswers: [String]?) {
        
        self.category = category
        self.difficulty = difficulty
        self.type = type
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
    }
    
}


class ParseQuizQuestion: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return "QuizQuestion"
    }
    
    @NSManaged var category: String?
    @NSManaged var difficulty: String?
    @NSManaged var type: String?
    @NSManaged var question: String?
    @NSManaged var correctAnswer: String?
    @NSManaged var incorrectAnswers: [String]?
    
}

ParseQuizQuestion.registerSubclass()



var allQuestions = [QuizQuestion]()
let dispatchGroup = DispatchGroup()

class QuestionGenerator {
    
    public func generateQuestions() {
        
 
        
      let url = URL(string: "https://opentdb.com/api.php?amount=50&token=e45cd0e70f061c334a3b6fbdec27722430efd6ba2015522ede69f00d3f1c357e")!
        
            print("Starting to generate questions...")
        
        
        for i in 0...100 {
            
                dispatchGroup.enter()
            
                Alamofire.request(url).responseJSON(completionHandler: {
                
                    dataResponse in
                    
                    dispatchGroup.leave()
                
                    guard  dataResponse.error == nil else {
                        print("There was an error running this request")
                    
                        return
                    }
                
                    guard let questionArray = self.buildQuestions(dataResponse.result.value) else {
                        print("Could not build questions")
                        return
                    }
                    
                    
                    if questionArray.count == 0 {
                        print("No more to come")
                        
                        
                    } else {
                        print("Got new questionset")
                        allQuestions.append(contentsOf: questionArray)
                        print("All questions count: \(allQuestions.count)")
                    }
                    
                    

                
            })
        
        }
        
        
       
        
    }
    
    
    fileprivate func buildQuestions(_ downloadedData: Any?) -> [QuizQuestion]? {
        
        guard let jsonData = downloadedData as? Dictionary<String, AnyObject> else {
            return nil
        }
        
        guard let questionArrayJson = jsonData["results"] as? Array<Dictionary<String, AnyObject>> else {
            return nil
        }
        
        var questionArray = [QuizQuestion]()
        
        for questionDict in questionArrayJson {
            let category = questionDict["category"] as? String
            let difficulty = questionDict["difficulty"] as? String
            let type = questionDict["type"] as? String
            let question = questionDict["question"] as? String
            let correctAnswer = questionDict["correct_answer"] as? String
            let incorrectAnswers = questionDict["incorrect_answers"] as? [String]
            
            let quizQuestion = QuizQuestion(category: category, difficulty: difficulty, type: type, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
            questionArray.append(quizQuestion)
        }
        
        return questionArray
        
    }
    
    fileprivate func buildUrl(catgory: Category, difficulty: Difficulty) -> URL? {
        
        var components = URLComponents()
        components.scheme = Constants.URL.Scheme
        components.host = Constants.URL.Host
        components.path = Constants.URL.Path
        
        var queryItems: [URLQueryItem] = []
        
        var categoryString = ""
        switch catgory {
            
        case Category.film:
            categoryString = Constants.QParamValues.Categories.Film
            break
        case Category.sports:
            categoryString = Constants.QParamValues.Categories.Sports
            break
        case Category.animals:
            categoryString = Constants.QParamValues.Categories.Animals
            break
        case Category.history:
            categoryString = Constants.QParamValues.Categories.History
            break
        case Category.mythology:
            categoryString = Constants.QParamValues.Categories.Mythology
            break
        case Category.geography:
            categoryString = Constants.QParamValues.Categories.Geography
            break
        case Category.scienceNature:
            categoryString = Constants.QParamValues.Categories.ScienceNature
            break
        case Category.generalKnowledge:
            categoryString = Constants.QParamValues.Categories.GeneralKnowledge
            break
        }
        queryItems.append(URLQueryItem(name: Constants.QParamsKeys.Amount, value: "50"))
        queryItems.append(URLQueryItem(name: Constants.QParamsKeys.Category, value: categoryString))
        queryItems.append(URLQueryItem(name: Constants.QParamsKeys.Difficulty, value: (difficulty.rawValue).lowercased()))
        
        queryItems.append(URLQueryItem(name: "token", value: "ac7ed02c562277854d17b1516f38e570fbb0b22aa36ec9c2231e851715108567"))
        components.queryItems = queryItems
        
        return components.url
    }
    
}



//let questionGener = QuestionGenerator()
//
//questionGener.generateQuestions()
//
//dispatchGroup.notify(queue: .main) {
//    
//    print("All questions downloaded")
//    handleResult()
//}
//
//
//let newDispatchGroup = DispatchGroup()
//
//func handleResult() {
//
//    for question in allQuestions {
//        
//        newDispatchGroup.enter()
//        let newPQ = ParseQuizQuestion()
//        newPQ.category = question.category
//        newPQ.difficulty = question.difficulty
//        newPQ.type = question.type
//        newPQ.question = question.question
//        newPQ.correctAnswer = question.correctAnswer
//        newPQ.incorrectAnswers = question.incorrectAnswers
//        
//        newPQ.saveInBackground(block: {
//            (bool, error) in
//            print(error)
//            print(bool)
//            newDispatchGroup.leave()
//            
//        })
//        
//    }
//}
//
//newDispatchGroup.notify(queue: .main) {
//    
//    print("Congrats!!")
//    print("All questions saved to parse!")
//}
//





//
//
//let query = PFQuery(className: "QuizQuestion")
//query.limit = 1000
//
//query.findObjectsInBackground(block: {
//    (objects, error) in
//    
//    print(error)
//    for obj in (objects!) {
//        print(obj)
//    }
//    
//
//})
//






