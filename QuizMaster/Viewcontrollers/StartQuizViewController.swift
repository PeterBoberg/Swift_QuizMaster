//
//  StartQuizViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-09.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: Public methods

class StartQuizViewController: UIViewController {

    // Set by calling view controller
    var category: Category!
    var difficulty: Difficulty!

    // Set by present view controller
    var speechSynth: SpeechSyntheziser!
    var questionGenerator: QuestionGenerator!
    var questions: [QuizQuestion]?
    var currentQuestionNumber: Int = 0
    var timer: Timer!
    var shouldSpeak: Bool!


    @IBOutlet weak var answerButtonStackView: UIStackView!
    @IBOutlet weak var answerButtonScrollView: UIScrollView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var timeSlider: UIProgressView!
    @IBOutlet weak var correctGuessLabel: UILabel!
    @IBOutlet weak var incorrectGuessLabel: UILabel!
    @IBOutlet weak var correctImageView: UIImageView!
    @IBOutlet weak var incorrectImageView: UIImageView!
    @IBOutlet weak var toggleSpeechButton: UIButton!
    @IBOutlet var leftMarginContraint: NSLayoutConstraint!
    @IBOutlet var rightMarginContraint: NSLayoutConstraint!


    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for const in view.constraints {
            print(const)
        }

        speechSynth = SpeechSyntheziser()
        questionGenerator = QuestionGenerator()
        shouldSpeak = UserDefaults.standard.bool(forKey: "speaking")
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
        if speechSynth.isSpeaking {
            stopSpeech()
        }

    }

    // MARK: UI Event methods
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
            speakQuestionIfNeeded(question: questions?[currentQuestionNumber])
        }
    }

}

// MARK: Private methods

extension StartQuizViewController {

    fileprivate func initUI() {
        questionTextView.layer.borderWidth = 2
        questionTextView.layer.borderColor = UIColor.yellow.cgColor
        questionTextView.layer.cornerRadius = 10
        questionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        leftMarginContraint.constant += self.view.bounds.width
        rightMarginContraint.constant += self.view.bounds.width
        timeSlider.setProgress(0, animated: false)
        var speachImage = ""
        if shouldSpeak {
            speachImage = "speech"
        } else {
            speachImage = "noSpeech"
        }
        toggleSpeechButton.setBackgroundImage(UIImage(named: speachImage), for: .normal)

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
                [unowned self] (bool) in
                self.shakeViews()
                self.startTimer()
                self.speakQuestionIfNeeded(question: self.questions?[self.currentQuestionNumber])
            })
        })

    }

    fileprivate func updateViewsWithCurrentQuestion() {

        emptyAnswerButtons()
        let questionObj = questions![currentQuestionNumber]
        guard let questionText = questionObj.question, let correctAnswer = questionObj.correctAnswer, let incorrectAnswers = questionObj.incorrectAnswers else {
            print("could not retrieve question info")
            return
        }

        questionTextView.text = questionText
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
                self.updateViewsWithCurrentQuestion()
                self.animateViews(direction: .backToScreen, completion: {
                    [unowned self] (bool) in
                    self.shakeViews()
                    self.startTimer()
                    self.speakQuestionIfNeeded(question: self.questions![self.currentQuestionNumber])
                })
            })
        } else {
            showResult()
        }
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
            self.leftMarginContraint.constant += leftContraintOffset
            self.rightMarginContraint.constant += rightConstraintOffset
            self.view.layoutIfNeeded()
        }

        if completion == nil {
            UIView.animate(withDuration: 0.25, animations: animationTasks)
        } else {
            UIView.animate(withDuration: 0.25, animations: animationTasks, completion: completion)
        }
    }


    private func showResult() {

        if let quizFinishedVc = self.storyboard?.instantiateViewController(withIdentifier: "QuizFinishedViewController") as? QuizFinishedViewController {
            let quizResult = QuizRoundResult(correctGuesses: correctGuessLabel.text!, incorrectGuesses: incorrectGuessLabel.text!, totalQuestions: String(questions!.count))
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

    fileprivate func speakQuestionIfNeeded(question: QuizQuestion?) {
        guard let questionString = question?.question, shouldSpeak else {
            return
        }
        self.speechSynth.speak(sentence: questionString)
    }

    fileprivate func stopSpeech() {
        if speechSynth.isSpeaking {
            speechSynth.stopImmediately()
        }
    }

    func shakeViews() {

        leftMarginContraint.isActive = false
        rightMarginContraint.isActive = false
        questionTextView.shake()
        answerButtonScrollView.shake()
        leftMarginContraint.isActive = true
        rightMarginContraint.isActive = true
        view.layoutIfNeeded()

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


