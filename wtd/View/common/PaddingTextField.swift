//
//  PaddingTextField.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/16.
//

import UIKit

class PaddingTextField: UITextField {
    //MARK: - properties ==================
    let padding: UIEdgeInsets
    
    //MARK: - lifecycle ==================
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
