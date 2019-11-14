//
//  QuestionNetwork.swift
//  ArchTouchChallenge
//
//  Created by Gustavo Cavalcanti on 13/11/19.
//  Copyright © 2019 Gustavo Cavalcanti. All rights reserved.
//

import Foundation

/// Download data and update QuestionModel.
class QuestionNetwork {
    /// Link to be download data
    private let link = "https://codechallenge.arctouch.com/quiz/1"
    /// Single instance of this class
    static let sharedInstance = QuestionNetwork()
    
    private init() {}
    
    /// Download data and update QuestionModel
    ///
    /// - Parameter completion: callback when done
    func downloadQuestion(completion: @escaping (_ questionModel: QuestionModel?) -> Void) {
        if let url = URL(string: link) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(QuestionModel.self, from: data)
                        completion(res)
                    } catch let _ {
                        completion(nil)
                    }
                }
                }.resume()
        }
    }
}
