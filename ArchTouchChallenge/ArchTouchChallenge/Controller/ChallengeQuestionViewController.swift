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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hitRate: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    
    /// View Model to help update answer data.
    private var challengeVM: ChallengeQuestionVM?
    /// View Model to help update the timer.
    private var timerVM: TimerVM?
    /// To show when load data.
    fileprivate var loadingAlert: UIViewController?
    /// True if the game has started, false otherwise.
    private var isStarted = false {
        didSet {
            // Only able to input text if the game has started.
            inputWordTextField.isUserInteractionEnabled = isStarted
        }
    }
    
    /// Text of the button when the game has started, and it's possible to restart.
    private let resetTextButton = "Reset"
    /// Text of the button when the game has not started, and it's possible to start.
    private let startTextButton = "Start"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        challengeVM = ChallengeQuestionVM(delegate: self)
        timerVM = TimerVM(delegate: self)
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        challengeVM?.loadData()
        timerVM?.setInitialTime()
    }
    
    @IBAction func clickStartResetButton(_ sender: Any) {
        if isStarted {
            reset()
        } else {
            startChallenge()
        }
    }
    
    /// Set properties to start the challenge.
    private func startChallenge() {
        startResetButton.setTitle(resetTextButton, for: .normal)
        timerVM?.startCount(completion: {
            let totalAnswerd = self.challengeVM?.foundedAnswer ?? 0
            let total = self.challengeVM?.totalAnswer ?? 0
            self.view.endEditing(true) // To hide the keyboard and not show when an alert is gone.
            let alert = AlertManager.sharedInstance.createTimeFinishedAlert(totalAnswered: totalAnswerd, total: total, actionButton: {
                self.reset()
            })
            
            self.present(alert, animated: true, completion: nil)
        })
        
        isStarted = true
    }
    
    /// Reset all parameters to initial values.
    private func reset() {
        startResetButton.setTitle(self.startTextButton, for: .normal)
        isStarted = false
        timerVM?.resetTimer()
        inputWordTextField.text = ""
        challengeVM?.resetAnswer()
        tableView.reloadData()
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
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func showCongratulationsAlert() {
        self.timerVM?.stopTimer()
        self.view.endEditing(true) // To hide the keyboard and not show when an alert is gone.
        
        let alert = AlertManager.sharedInstance.createCongratulationAlert {
            self.reset()
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TimerVMDelegate

extension ChallengeQuestionViewController: TimerVMDelegate {
    func setTime(time: String) {
        timeLabel.text = time
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ChallengeQuestionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeVM?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = challengeVM?.getAnswer(byIndex: indexPath.row)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension ChallengeQuestionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let answer = textField.text {
            challengeVM?.addAnswer(answer: answer)
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}
