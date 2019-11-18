//
//  AlertManager.swift
//  ArchTouchChallenge
//
//  Created by Gustavo Cavalcanti on 14/11/19.
//  Copyright © 2019 Gustavo Cavalcanti. All rights reserved.
//

import UIKit

/// To create different alerts.
class AlertManager {
    private let timeFinishedTitle = "Time finished"
    private let timeFinishedMessage = "Sorry, time is up! You got %d out of %d answers."
    private let timeFinishedTextButton = "Try Again"
    
    private let congratulationTitle = "Congratulations"
    private let congratulationMessage = "Good job! You found all the answers on time. Keep up with the great work."
    private let congratulationTextButton = "Play Again"
    
    /// To get the single instance of this class.
    static let sharedInstance = AlertManager()
    
    private init() {}
    
    /// Create an alert with a time finished message.
    ///
    /// - Parameters:
    ///   - totalAnswered: amount of questions answered.
    ///   - total: total of the questions.
    ///   - actionButton: action when button is pressed
    /// - Returns: alert configured
    func createTimeFinishedAlert(totalAnswered: Int, total: Int, actionButton: @escaping () -> Void) -> UIAlertController {
        let messageFormatted = String(format: timeFinishedMessage, totalAnswered, total)
        return createAlert(title: timeFinishedTitle, message: messageFormatted, textButton: timeFinishedTextButton, actionButton: actionButton)
    }
    
    /// Create an alert with a congratulation message.
    ///
    /// - Parameter actionButton: action when button is pressed
    /// - Returns: alert configured
    func createCongratulationAlert(actionButton: @escaping () -> Void) -> UIAlertController {
        return createAlert(title: congratulationTitle, message: congratulationMessage, textButton: congratulationTextButton, actionButton: actionButton)
    }
    
    /// Create an alert.
    ///
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: message of alert
    ///   - textButton: text of single button
    ///   - actionButton: action when button is pressed.
    /// - Returns: alert configured.
    private func createAlert(title: String, message: String, textButton: String, actionButton: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: textButton, style: UIAlertAction.Style.default) { _ in
            actionButton()
        })
        
        return alert
    }
}
