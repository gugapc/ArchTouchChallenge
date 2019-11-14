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
    
    init(delegate: TimerVMDelegate) {
        self.delegate = delegate
    }
    
    /// Start to decreasing the timer.
    func startCount() {
        var minutes = 5
        var seconds = 0
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if (seconds == 0) {
                minutes -= 1
                seconds = 59
            } else {
                seconds -= 1
            }
            
            let minFormatted = String(format: "%02d", minutes)
            let secFormatted = String(format: "%02d", seconds)
            
            let time = "\(minFormatted):\(secFormatted)"
            
            self.delegate.setTime(time: time)

            if minutes == 0 && seconds == 0 {
                timer.invalidate()
            }
        }
    }
}
