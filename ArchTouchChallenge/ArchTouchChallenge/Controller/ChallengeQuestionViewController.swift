//
//  ViewController.swift
//  ArchTouchChallenge
//
//  Created by Gustavo Cavalcanti on 13/11/19.
//  Copyright © 2019 Gustavo Cavalcanti. All rights reserved.
//

import UIKit

/// Controller of ChallengeQuestion.
class ChallengeQuestionViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputWordTextField: UITextField!
    
    private var challengeVM: ChallengeQuestionVM?
    fileprivate var loadingAlert: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        challengeVM = ChallengeQuestionVM(delegate: self)
        // TODO: Remove border of textfield.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        challengeVM?.loadData()
    }
}

// MARK: - ChallengeQuestionVMDelegate

extension ChallengeQuestionViewController: ChallengeQuestionVMDelegate {
    func presentLoad() {
        let storyboard = UIStoryboard(name: "LoadingAlert", bundle: .main)
        loadingAlert = storyboard.instantiateViewController(withIdentifier: "LoadingAlertID")

        if let alert = loadingAlert {
            present(alert, animated: true)
        }
    }
    
    func dismissLoad() {
        if let alert = loadingAlert {
            alert.dismiss(animated: true, completion: nil)
        }
    }

    func set(title: String) {
        titleLabel.text = title
    }
}
