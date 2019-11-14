//
//  QuestionModel.swift
//  ArchTouchChallenge
//
//  Created by Gustavo Cavalcanti on 13/11/19.
//  Copyright © 2019 Gustavo Cavalcanti. All rights reserved.
//

import Foundation

/// Model to receive Json of questions.
struct QuestionModel: Codable {
    /// Title of question
    let question: String
    /// List of answer
    let answer: [String]
}
