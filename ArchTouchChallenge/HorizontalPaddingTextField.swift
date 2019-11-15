//
//  HorizontalPaddingTextField.swift
//  ArchTouchChallenge
//
//  Created by Gustavo Cavalcanti on 15/11/19.
//  Copyright © 2019 Gustavo Cavalcanti. All rights reserved.
//

import UIKit

/// Add horizontal padding to UITextField
class HorizontalPaddingTextField: UITextField {
    /// The padding to be added.
    let padding = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
