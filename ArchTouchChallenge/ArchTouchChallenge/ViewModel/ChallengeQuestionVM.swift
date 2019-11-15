//
//  ChallengeQuestionVM.swift
//  ArchTouchChallenge
//
//  Created by Gustavo Cavalcanti on 14/11/19.
//  Copyright © 2019 Gustavo Cavalcanti. All rights reserved.
//

import Foundation

protocol ChallengeQuestionVMDelegate {
    /// Show the load alert.
    func presentLoad()
    /// Dismiss the load alert.
    func dismissLoad()
    /// To set title.
    ///
    /// - Parameter title: title to be setted.
    func set(title: String)
    /// To set the rate of the answer
    ///
    /// - Parameter answerRate: answer rate to be setted.
    func set(hitRate: String)
    /// Reload table when data changed.
    func reloadTable()
    /// Show alert when complete the challenger.
    func showCongratulationsAlert()
}

/// Responsible for managing the question, the list of answer and the hit rate.
class ChallengeQuestionVM {
    /// To retrieve question model data.
    private var questionModel: QuestionModel?
    /// The delegate to execute some function on the controller.
    private let delegate: ChallengeQuestionVMDelegate
    
    private var foundedAnswersList = [String]()
    
    var totalAnswer: Int {
        get {
            return questionModel?.answer.count ?? 0
        }
    }
    
    var foundedAnswer: Int {
        get {
            return foundedAnswersList.count
        }
    }
    
    /// To calculate the hit ratio of the questions.
    private var hitRate: String {
        get {
            if let questionModel = questionModel {
                let totalAnswers = questionModel.answer.count
                let formattedFoundAnswers = String(format: "%02d", foundedAnswersList.count)
                let formattedTotalAnswers = String(format: "%02d", totalAnswers)
                
                return "\(formattedFoundAnswers)/\(formattedTotalAnswers)"
            }
            
            return "00/00"
        }
    }
    
    init(delegate: ChallengeQuestionVMDelegate) {
        self.delegate = delegate
    }

    /// Load data and update screen.
    func loadData() {
        delegate.presentLoad()
        QuestionNetwork.sharedInstance.downloadQuestion { (questionModel) in
            self.questionModel = questionModel
            DispatchQueue.main.async {
                self.delegate.dismissLoad()
                if let questionModel = questionModel {
                    self.delegate.set(title: questionModel.question)
                    self.delegate.set(hitRate: self.hitRate)
                }
            }
        }
    }
    
    /// Check if the answer is correct, if it is, adds to the founded answer.
    ///
    /// - Parameter answer: the answer to be added.
    func addAnswer(answer: String) {
        let formattedAnswer = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        print(formattedAnswer)
        if (questionModel?.answer.contains(formattedAnswer) ?? false) {
            foundedAnswersList.insert(formattedAnswer, at: 0)
            delegate.reloadTable()
            delegate.set(hitRate: hitRate)
        }
        
        if (questionModel?.answer.count == foundedAnswersList.count) {
            delegate.showCongratulationsAlert()
        }
    }
    
    /// Remove all founded answer and update the hit rate.
    func resetAnswer() {
        foundedAnswersList.removeAll()
        delegate.set(hitRate: hitRate)
    }
    
// MARK: - tableView

    func numberOfRows() -> Int {
        return foundedAnswersList.count
    }
    
    /// Get the answer of founded answer.
    ///
    /// - Parameter index: the index of the answer.
    /// - Returns: the answer according to the index.
    func getAnswer(byIndex index: Int) -> String {
        return foundedAnswersList[index]
    }
}
