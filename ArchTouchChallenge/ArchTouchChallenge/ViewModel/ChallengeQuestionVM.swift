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
}

/// Responsible for managing the question, the list of answer and the hit rate.
class ChallengeQuestionVM {
    private let delegate: ChallengeQuestionVMDelegate
    private var questionModel: QuestionModel?
    
    private var foundedAnswers = [String]()
    
    /// To calculate the hit ratio of the questions.
    private var hitRate: String {
        get {
            if let questionModel = questionModel {
                let totalAnswers = questionModel.answer.count
                let formattedFoundAnswers = String(format: "%02d", foundedAnswers.count)
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
}
