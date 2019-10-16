//
//  File.swift
//  Stitch3D
//
//  Created by You-Wen Ji on 8/31/19.
//  Copyright © 2019 You-Wen Ji. All rights reserved.
//

import Foundation
import UIKit

class StateButton: UIButton {
    var isON = false
    var currentState = 0
    var defaultColor: UIColor
    
    required init(color: UIColor) {
        self.defaultColor = color
        super.init(frame: .zero)
        layer.borderWidth = 2.0
        layer.borderColor = color.cgColor
        backgroundColor = .clear
        tintColor = color
        setTitleColor(color, for: .normal)
        addTarget(self, action: #selector(StateButton.buttonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed() {
        if isON {
            isON = false
            currentState = 0
        }
        else {
            isON = true
            currentState = 1
        }
        let color = isON ? defaultColor : .clear
        let titleColor = isON ? .systemBackground : defaultColor
        backgroundColor = color
        setTitleColor(titleColor, for: .normal)
    }
}
