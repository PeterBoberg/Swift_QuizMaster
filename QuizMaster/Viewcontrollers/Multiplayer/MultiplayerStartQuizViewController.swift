//
//  MultiplayerStartQuizViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-02.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class MultiplayerStartQuizViewController: UIViewController {

    // Set by presenting viewController
    var quizMatch: QuizMatch!

    // Set by this ViewController
    var timer: Timer!
    var currentQuestionNumber: Int = 0
    var speechSynth: SpeechSyntheziser!
    var shouldSpeak: Bool!
    var progressViewController: ProgressIndicatorViewController!


    fileprivate var cleanedQuestions: [HTMLCleanedQuestion]!

    @IBOutlet weak var answerButtonScrollView: UIScrollView!
    @IBOutlet weak var answerButtonStackView: UIStackView!
    @IBOutlet weak var correctGuessesLabel: UILabel!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var toggleSpeechButton: UIButton!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeSlider: UIProgressView!

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        speechSynth = SpeechSyntheziser()
        shouldSpeak = UserDefaults.standard.bool(forKey: "speaking")
        cleanedQuestions = [HTMLCleanedQuestion]()
        progressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProgressIndicatorViewController") as! ProgressIndicatorViewController
        progressViewController.modalTransitionStyle = .crossDissolve
        progressViewController.modalPresentationStyle = .overCurrentContext
        initUI()
        downloadQuestions()
    }


    // MARK: UI Event methods

    public func answerButtonPressed(sender: UIButton) {
        let button = sender as! AnswerButton
        switch button.isCorrectButton {
        case true:
            correctGuessesLabel.text = String(Int(correctGuessesLabel.text!)! + 1)
            break
        case false:
            incorrectGuessesLabel.text = String(Int(incorrectGuessesLabel.text!)! + 1)
            break
        }
        moveToNextQuestion()
    }

    @IBAction func toggleSpeech(_ sender: UIButton) {

        if shouldSpeak {
            shouldSpeak = false
            UserDefaults.standard.set(false, forKey: "speaking")
            toggleSpeechButton.setBackgroundImage(UIImage(named: "noSpeech"), for: .normal)
            if speechSynth.isSpeaking {
                stopSpeech()
            }
        } else {
            shouldSpeak = true
            UserDefaults.standard.set(true, forKey: "speaking")
            toggleSpeechButton.setBackgroundImage(UIImage(named: "speech"), for: .normal)
            speakQuestionIfNeeded(question: cleanedQuestions[currentQuestionNumber])
        }

    }

    deinit {
        print("MultiplayerStartQuizViewController destroyed")
    }
}


// MARK: Private Methods

extension MultiplayerStartQuizViewController {

    fileprivate func initUI() {
        questionTextView.layer.borderWidth = 2
        questionTextView.layer.borderColor = UIColor.gray.cgColor
        questionTextView.layer.cornerRadius = 10
        questionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        leftMarginConstraint.constant += self.view.bounds.width
        rightMarginConstraint.constant += self.view.bounds.width
        timeSlider.setProgress(0, animated: false)
        var speechImage = ""
        if shouldSpeak {
            speechImage = "speech"
        } else {
            speechImage = "noSpeech"
        }
        toggleSpeechButton.setBackgroundImage(UIImage(named: speechImage), for: .normal)

    }

    fileprivate func downloadQuestions() {

        self.present(progressViewController, animated: true)
        let dispacthGroup = DispatchGroup()

        guard let questionSet = quizMatch.questions else {
            print("Could not retrieve questions")
            return
        }
        for question in questionSet {
            dispacthGroup.enter()
            question.fetchIfNeededInBackground(block: {
                [unowned self] (object, error) in
                dispacthGroup.leave()
                guard error == nil else {
                    print(error)
                    return
                }
                if let questionObj = object as? PQuizQuestion {
                    self.addToHTMLConverterQuestions(questionObj)
                } else {
                    print("Could not cast questionObj to PQuizQuestion: \(object)")
                }

            })
        }

        dispacthGroup.notify(queue: .main, execute: {
            [unowned self] in
            self.progressViewController.dismiss(animated: true)
            self.downLoadDone()
        })
    }

    fileprivate func downLoadDone() {
        print("Converting done...")
        updateViewsWithCurrentQuestions()
        animateViews(direction: .backToScreen, completion: {
            [unowned self] (bool) in
            self.shakeViews()
            self.startTimer()
            self.speakQuestionIfNeeded(question: self.cleanedQuestions[self.currentQuestionNumber])
        })
    }


    fileprivate func animateViews(direction: Direction, completion: ((Bool) -> Void)?) {

        var leftContraintOffset = self.view.bounds.width
        var rightConstraintOffset = self.view.bounds.width


        switch direction {
        case .awayFromScreen:
            break
        case .backToScreen:
            leftContraintOffset *= CGFloat(-1)
            rightConstraintOffset *= CGFloat(-1)
            break
        }

        let animationTasks = {
            self.leftMarginConstraint.constant += leftContraintOffset
            self.rightMarginConstraint.constant += rightConstraintOffset
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.25, animations: animationTasks, completion: completion)
    }

    fileprivate func updateViewsWithCurrentQuestions() {

        emptyAnswerButtons()
        let currentQuestion = self.cleanedQuestions[currentQuestionNumber]

        guard let question = currentQuestion.question,
              let correctAnswer = currentQuestion.correctAnswer,
              let incorrectAnswers = currentQuestion.incorrectAnswers else {
            print("Could not unpack question detailed info, question no: \(currentQuestionNumber)")
            return
        }

        questionTextView.text = question
        let shuffledButtons = makeShuffledButtons(fromCorrectAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
        for button in shuffledButtons {
            answerButtonStackView.addArrangedSubview(button)
        }


    }

    fileprivate func moveToNextQuestion() {

        timer.invalidate()
        currentQuestionNumber += 1
        stopSpeech()

        if haveMoreQuestions() {
            self.timeSlider.setProgress(0, animated: false)
            animateViews(direction: .awayFromScreen, completion: {
                [unowned self] (bool) in
                self.updateViewsWithCurrentQuestions()
                self.animateViews(direction: .backToScreen, completion: {
                    [unowned self] (bool) in
                    self.shakeViews()
                    self.startTimer()
                    self.speakQuestionIfNeeded(question: self.cleanedQuestions[self.currentQuestionNumber])
                })
            })
        } else {
            print("No more questions")
            handleQuizRoundOver()
        }
    }


    fileprivate func handleQuizRoundOver() {

        let correctAnswers = Int(self.correctGuessesLabel.text!)!
        GameEngine.shared.handleQuizRoundFinished(quizMatch: quizMatch, correctAnswers: correctAnswers, completion: {
            [unowned self] (success, error) in
            guard error == nil else {
                // TODO better error handling
                print(error)
                return
            }

            if self.quizMatchOver() {

                let quizFinishedResult = GameEngine.shared.computeResultFrom(quizMatch: self.quizMatch)
                let quizFinishedVc = self.storyboard?.instantiateViewController(withIdentifier: "MultiplayerQuizFinishedViewController") as! MultiplayerQuizFinishedViewController
                quizFinishedVc.quizFinishedResult = quizFinishedResult
                quizFinishedVc.modalPresentationStyle = .overCurrentContext
                quizFinishedVc.modalTransitionStyle = .crossDissolve
                quizFinishedVc.navController = self.navigationController
                self.present(quizFinishedVc, animated: true)


            } else {

                let quizPassoverResult = QuizPassoverResult(challengerName: self.quizMatch.challenger?.username, correctAnswers: self.correctGuessesLabel.text)
                let passoverVc = self.storyboard?.instantiateViewController(withIdentifier: "MultiplayerQuizRoundPassoverViewController") as! MultiplayerQuizRoundPassoverViewController
                passoverVc.quizPassoverResult = quizPassoverResult
                passoverVc.modalPresentationStyle = .overCurrentContext
                passoverVc.modalTransitionStyle = .crossDissolve
                passoverVc.navController = self.navigationController
                self.present(passoverVc, animated: true)

            }
        })

    }

    fileprivate func stopSpeech() {
        if speechSynth.isSpeaking {
            speechSynth.stopImmediately()
        }
    }

    fileprivate func quizMatchOver() -> Bool {
        return GameEngine.shared.quizFinished(quizMatch: quizMatch)
    }


    fileprivate func shakeViews() {
        questionTextView.shake()
        answerButtonScrollView.shake()
        view.layoutIfNeeded()
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
            incorrectGuessesLabel.text = String(Int(incorrectGuessesLabel.text!)! + 1)
            moveToNextQuestion()
            break
        }
    }

    fileprivate func haveMoreQuestions() -> Bool {
        return currentQuestionNumber < cleanedQuestions.count
    }

    fileprivate func isFirstQuestion() -> Bool {
        return currentQuestionNumber == 0
    }


}

// MARK: Utility methods

extension MultiplayerStartQuizViewController {

    fileprivate func makeShuffledButtons(fromCorrectAnswer correctAnswer: String,
                                         incorrectAnswers: [String]) -> [AnswerButton] {

        var buttonArray = [AnswerButton]()
        buttonArray.append(makeButton(withText: correctAnswer, correctButton: true))
        for incorrectAnswer in incorrectAnswers {
            buttonArray.append(makeButton(withText: incorrectAnswer, correctButton: false))
        }

        buttonArray.shuffleInPlace()
        return buttonArray
    }

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

    fileprivate func addToHTMLConverterQuestions(_ questionObj: PQuizQuestion) {

        do {
            if let question = questionObj.question, let corrrectAnswer = questionObj.correctAnswer, let incorrectAnswers = questionObj.incorrectAnswers {
                let cleanedQuestion = try question.convertHtmlSymbols()
                let cleanedCorrectAnswer = try corrrectAnswer.convertHtmlSymbols()
                var cleanedIncorrectAnswers = [String]()
                for incorrectAnswer in incorrectAnswers {
                    cleanedIncorrectAnswers.append(try incorrectAnswer.convertHtmlSymbols()!)
                }

                let cleanedConvertedQuestion = HTMLCleanedQuestion(question: cleanedQuestion, correctAnswer: cleanedCorrectAnswer, incorrectAnswers: cleanedIncorrectAnswers)
                cleanedQuestions.append(cleanedConvertedQuestion)
            }
        } catch let convertError {
            print(convertError)
        }
    }


    fileprivate func emptyAnswerButtons() {
        for view in answerButtonStackView.subviews {
            view.removeFromSuperview()
        }
    }

    fileprivate func speakQuestionIfNeeded(question: HTMLCleanedQuestion?) {
        guard let questionObj = question, let questionString = questionObj.question, shouldSpeak else {
            return
        }
        self.speechSynth.speak(sentence: questionString)
    }


}


fileprivate struct HTMLCleanedQuestion {
    let question: String?
    let correctAnswer: String?
    let incorrectAnswers: [String]?

    init(question: String?, correctAnswer: String?, incorrectAnswers: [String]?) {
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
    }
}


struct QuizPassoverResult {
    let challengerName: String?
    let correctAnswers: String?

    init(challengerName: String?, correctAnswers: String?) {
        self.challengerName = challengerName
        self.correctAnswers = correctAnswers
    }
}

struct QuizFinishedResult {
    let challengerName: String?
    let challengedName: String?
    let challengerCorrectGuesses: String?
    let challengerIncorrectGuesses: String?
    let challengedCorrectGuesses: String?
    let challengedIncorrectGuesses: String?
    let winner: String?

    init(challengerName: String?, challengedName: String?, challengerCorrectGuesses: String?,
         challengerIncorrectGuesses: String?, challengedCorrectGuesses: String?,
         challengedIncorrectGuesses: String?, winner: String?) {

        self.challengerName = challengerName
        self.challengedName = challengedName
        self.challengerCorrectGuesses = challengerCorrectGuesses
        self.challengerIncorrectGuesses = challengerIncorrectGuesses
        self.challengedCorrectGuesses = challengedCorrectGuesses
        self.challengedIncorrectGuesses = challengedIncorrectGuesses
        self.winner = winner
    }
}