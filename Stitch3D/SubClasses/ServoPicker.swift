//
//  servoPicker.swift
//  Stitch3D
//
//  Created by You-Wen Ji on 8/31/19.
//  Copyright © 2019 You-Wen Ji. All rights reserved.
//

import Foundation
import UIKit

class VelocityPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var numbers = [Int](0...34)
    var velocities = [String]()
    func modifyNumber(){
        for i in numbers {
            if i == 17 { numbers[i] = 0 }
            else if i == 0 { numbers[i] = 1023}
            else if i < 17 && i != 0{ numbers[i] = 1000 - (i-1) * 50}
            else if i > 17 && i != 34{ numbers[i] = -250 - (i-18) * 50}
            else{ numbers[i] = -1023}
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return velocities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return velocities[row]
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        modifyNumber()
        self.velocities = numbers.map { String($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PositionPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var numbers = [Int](0...102)
    var velocities = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return velocities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return velocities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        label.text = velocities[row]
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        let view = UIView(frame:  CGRect(x: 0, y: 0, width: 30, height: 30))
        let gradient = CAGradientLayer()
        view.addSubview(label)
        
        view.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.systemGray5.cgColor, UIColor.systemBackground.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.velocities = numbers.map { String($0 * 10) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
