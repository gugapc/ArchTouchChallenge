//
//  ChallengeQuestionVM.swift
//  ArchTouchChallenge
//
//  Created by Gustavo Cavalcanti on 14/11/19.
//  Copyright © 2019 Gustavo Cavalcanti. All rights reserved.
//

import Foundation

protocol ChallengeQuestionVMDelegate {
    /// Show the load alert
    func presentLoad()
    /// Dismiss the load alert
    func dismissLoad()
}

/// Responsible to manage the question, the list of answer and the hit rate.
class ChallengeQuestionVM {
    private var delegate: ChallengeQuestionVMDelegate
    
    init(delegate: ChallengeQuestionVMDelegate) {
        self.delegate = delegate
    }

    func loadData() {
        delegate.presentLoad()
        QuestionNetwork.sharedInstance.downloadQuestion {
            DispatchQueue.main.async {
                self.delegate.dismissLoad()
            }
        }
    }
}
