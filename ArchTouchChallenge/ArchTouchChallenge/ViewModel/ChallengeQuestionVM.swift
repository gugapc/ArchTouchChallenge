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
}

/// Responsible to manage the question, the list of answer and the hit rate.
class ChallengeQuestionVM {
    private var delegate: ChallengeQuestionVMDelegate
    private var questionModel: QuestionModel?
    
    init(delegate: ChallengeQuestionVMDelegate) {
        self.delegate = delegate
    }

    func loadData() {
        delegate.presentLoad()
        QuestionNetwork.sharedInstance.downloadQuestion { (questionModel) in
            self.questionModel = questionModel
            DispatchQueue.main.async {
                self.delegate.dismissLoad()
                if let questionModel = questionModel {
                    self.delegate.set(title: questionModel.question)
                }
            }
        }
    }
}
