//
//  TimerVM.swift
//  ArchTouchChallenge
//
//  Created by Gustavo Cavalcanti on 14/11/19.
//  Copyright © 2019 Gustavo Cavalcanti. All rights reserved.
//

import Foundation

protocol TimerVMDelegate {
    /// To set the time
    ///
    /// - Parameter time: time to be setted.
    func setTime(time: String)
}

/// Responsible for managing the time of the challenge and notify when it ends.
class TimerVM {
    private let delegate: TimerVMDelegate
    private var timer: Timer?
    
    private let totalMin = 1
    private let totalSec = 0
    
    init(delegate: TimerVMDelegate) {
        self.delegate = delegate
    }
    
    /// Start to decreasing the timer.
    ///
    /// - Parameter completion: callback when finished.
    func startCount(completion: @escaping () -> Void) {
        var minutes = totalMin
        var seconds = totalSec
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if (seconds == 0) {
                minutes -= 1
                seconds = 59
            } else {
                seconds -= 1
            }
            
            let time = self.getTimeFormatted(minutes: minutes, seconds: seconds)
            
            self.delegate.setTime(time: time)

            if minutes == 0 && seconds == 0 {
                timer.invalidate()
                completion()
            }
        }
    }
    
    /// Invalidate timer if already started and put it to initial value.
    func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            setInitialTime()
        }
    }
    
    /// Put a timer to initial value.
    func setInitialTime() {
        let time = self.getTimeFormatted(minutes: totalMin, seconds: totalSec)
        self.delegate.setTime(time: time)
    }
    
    /// Format the time to have two decimal places, and separated by a colon.
    ///
    /// - Parameters:
    ///   - minutes: value of minutes
    ///   - seconds: value of seconds
    /// - Returns: time formatted.
    private func getTimeFormatted(minutes: Int, seconds: Int) -> String {
        let minFormatted = String(format: "%02d", minutes)
        let secFormatted = String(format: "%02d", seconds)
        
        return "\(minFormatted):\(secFormatted)"
    }
}
