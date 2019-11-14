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
    @IBOutlet weak var hitRate: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    
    private var challengeVM: ChallengeQuestionVM?
    private var timerVM: TimerVM?
    fileprivate var loadingAlert: UIViewController?
    private var isStarted = false
    
    private let resetText = "Reset"
    private let startText = "Start"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        challengeVM = ChallengeQuestionVM(delegate: self)
        timerVM = TimerVM(delegate: self)
        // TODO: Remove border of textfield.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        challengeVM?.loadData()
        timerVM?.setInitialTime()
    }
    
    @IBAction func clickStartResetButton(_ sender: Any) {
        if isStarted {
            startResetButton.setTitle(startText, for: .normal)
            timerVM?.resetTimer()
        } else {
            startResetButton.setTitle(resetText, for: .normal)
            timerVM?.startCount(completion: {
                let alert = AlertManager.sharedInstance.createTimeFinishedAlert(totalAnswered: 0, total: 50, actionButton: {
                    self.startResetButton.setTitle(self.startText, for: .normal)
                    self.isStarted = false
                    self.timerVM?.resetTimer()
                })

                self.present(alert, animated: true, completion: nil)
            })
        }
        
        isStarted = !isStarted
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
    
    func set(hitRate: String) {
        self.hitRate.text = hitRate
    }
}

// MARK: - TimerVMDelegate

extension ChallengeQuestionViewController: TimerVMDelegate {
    func setTime(time: String) {
        timeLabel.text = time
    }
}
