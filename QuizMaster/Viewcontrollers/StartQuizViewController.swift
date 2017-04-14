//
//  StartQuizViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-09.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

// MARK: Public methods

class StartQuizViewController: UIViewController {

    // Set by calling view controller
    var category: Category!
    var difficulty: Difficulty!

    // Set by present view controller
    var questionGenerator: QuestionGenerator!
    var questions: [QuizQuestion]?
    var currentQuestionNumber: Int = 0
    var timer: Timer!

    @IBOutlet weak var answerButtonStackView: UIStackView!
    @IBOutlet weak var answerButtonScrollView: UIScrollView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var timeSlider: UIProgressView!
    @IBOutlet weak var correctGuessLabel: UILabel!
    @IBOutlet weak var incorrectGuessLabel: UILabel!
    @IBOutlet weak var correctImageView: UIImageView!
    @IBOutlet weak var incorrectImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        questionGenerator = QuestionGenerator()
        downloadQuestions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer.isValid {
            timer.invalidate()
        }
    }

    public func answerButtonPressed(sender: UIButton) {
        let button = sender as! AnswerButton
        switch button.isCorrectButton {
        case true:
            correctGuessLabel.text = String(Int(correctGuessLabel.text!)! + 1)
            break
        case false:
            incorrectGuessLabel.text = String(Int(incorrectGuessLabel.text!)! + 1)
            break
        }
        moveToNextQuestion()
    }


}

// MARK: Private methods

extension StartQuizViewController {

    fileprivate func initUI() {
        questionTextView.layer.borderWidth = 2
        questionTextView.layer.borderColor = UIColor.yellow.cgColor
        questionTextView.layer.cornerRadius = 10
        questionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        answerButtonStackView.translatesAutoresizingMaskIntoConstraints = true
        questionTextView.translatesAutoresizingMaskIntoConstraints = true
        correctImageView.translatesAutoresizingMaskIntoConstraints = true
        incorrectImageView.translatesAutoresizingMaskIntoConstraints = true
        correctGuessLabel.translatesAutoresizingMaskIntoConstraints = true
        incorrectGuessLabel.translatesAutoresizingMaskIntoConstraints = true
        timeSlider.translatesAutoresizingMaskIntoConstraints = true
        questionTextView.setYOffset(withFloat: self.view.bounds.height * CGFloat(-1))
//        answerButtonStackView.setXOffset(withFloat: self.view.bounds.width)
        answerButtonScrollView.setXOffset(withFloat: self.view.bounds.width)
        timeSlider.setProgress(0, animated: false)
    }

    fileprivate func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }

    @objc fileprivate func handleTimer() {
        let currentSlideValue = timeSlider.progress;

        switch currentSlideValue {
        case 0..<1:
            timeSlider.setProgress(currentSlideValue + 0.008, animated: true)
            break

        default:
            incorrectGuessLabel.text = String(Int(incorrectGuessLabel.text!)! + 1)
            moveToNextQuestion()
            break
        }
    }

    fileprivate func downloadQuestions() {

        questionGenerator.generateQuestions(category: category, difficulty: difficulty!, completionHandler: {
            (returnedQuestions, error) in

            guard error == nil else {
                print(error)
                return
            }
            guard let returnedQuestions = returnedQuestions else {
                print("Questions was nil")
                return
            }
            self.questions = returnedQuestions
            self.updateViewsWithCurrentQuestion()
            self.animateViews(direction: .backToScreen, completion: {
                (bool) in
                self.questionTextView.shake()
//                self.answerButtonStackView.shake()
                self.answerButtonScrollView.shake()
                self.startTimer()
            })
        })

    }

    fileprivate func updateViewsWithCurrentQuestion() {

        emptyAnswerButtons()
        let questionObj = questions![currentQuestionNumber]
        guard let questionText = questionObj.question, let correctAnswer = questionObj.correctAnswer, let incorrectAnswers = questionObj.incorrectAnswers else {
            print("could not retrieve quesion info")
            return
        }

        questionTextView.text = questionText
        let shuffeledButtons = makeShuffledButtons(fromCorrectAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)

        for button in shuffeledButtons {
            answerButtonStackView.addArrangedSubview(button)
        }
    }


    fileprivate func moveToNextQuestion() {

        timer.invalidate()
        currentQuestionNumber += 1

        if haveMoreQuestions() {
            self.timeSlider.setProgress(0, animated: false)
            animateViews(direction: .awayFromScreen, completion: {
                (bool) in
                self.updateViewsWithCurrentQuestion()
                self.animateViews(direction: .backToScreen, completion: {
                    (bool) in
                    self.questionTextView.shake()
//                    self.answerButtonStackView.shake()
                    self.answerButtonScrollView.shake()
                    self.startTimer()
                })
            })
        } else {
            showResult()
        }
    }


    fileprivate func animateViews(direction: Direction, completion: ((Bool) -> Void)?) {

        var xOffset = self.view.bounds.width
        var yOffset = self.view.bounds.height

        switch direction {
        case .awayFromScreen:
            yOffset *= CGFloat(-1)
            break
        case .backToScreen:
            xOffset *= CGFloat(-1)
            break
        }

        let animationTasks = {
            self.questionTextView.setYOffset(withFloat: yOffset)
//            self.answerButtonStackView.setXOffset(withFloat: xOffset)
            self.answerButtonScrollView.setXOffset(withFloat: xOffset)
        }

        if completion == nil {
            UIView.animate(withDuration: 0.3, animations: animationTasks)
        } else {
            UIView.animate(withDuration: 0.3, animations: animationTasks, completion: completion)
        }
    }

    private func showResult() {

        if let quizFinishedVc = self.storyboard?.instantiateViewController(withIdentifier: "QuizFinishedViewController") as? QuizFinishedViewController {
            let quizResult = QuizResult(correctGuesses: correctGuessLabel.text!, incorrectGuesses: incorrectGuessLabel.text!, totalQuestions: String(questions!.count))
            quizFinishedVc.quizResult = quizResult
            quizFinishedVc.navController = self.navigationController
            self.present(quizFinishedVc, animated: true, completion: nil)
        }
    }


    private func makeShuffledButtons(fromCorrectAnswer correctAnswer: String,
                                     incorrectAnswers: [String]) -> [AnswerButton] {

        var buttonArray = [AnswerButton]()
        buttonArray.append(makeButton(withText: correctAnswer, correctButton: true))
        for incorrectAnswer in incorrectAnswers {
            buttonArray.append(makeButton(withText: incorrectAnswer, correctButton: false))
        }

        buttonArray.shuffleInPlace()
        return buttonArray
    }

    fileprivate func haveMoreQuestions() -> Bool {
        return self.currentQuestionNumber < self.questions!.count - 1
    }

    fileprivate func isFirstQuestion() -> Bool {
        return currentQuestionNumber == 0
    }


}

//MARK: Utility methods

extension StartQuizViewController {

    fileprivate func makeButton(withText text: String, correctButton: Bool) -> AnswerButton {

        let button = AnswerButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel!.font = UIFont(name: "Arial", size: 25)
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(2), blue: CGFloat(3), alpha: CGFloat(0.2))
        button.isCorrectButton = correctButton
        button.setTitleColor(UIColor.yellow, for: .normal)
        button.addTarget(self, action: #selector(answerButtonPressed(sender:)), for: .touchUpInside)
        button.makeRounded()
        return button
    }

    fileprivate func emptyAnswerButtons() {
        for view in answerButtonStackView.subviews {
            view.removeFromSuperview()
        }
    }

}

private enum Direction {
    case awayFromScreen, backToScreen

}


