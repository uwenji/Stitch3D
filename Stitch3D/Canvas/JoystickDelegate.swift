//
//  L_JoystickDelegate.swift
//  Stitch3D
//
//  Created by You-Wen Ji on 9/16/19.
//  Copyright © 2019 You-Wen Ji. All rights reserved.
//

import Foundation
import UIKit

extension JoystickController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wheelPicker.velocities.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wheelPicker.velocities[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        needlePosition = needlePicker.numbers[needlePicker.selectedRow(inComponent: 0)] * 10
        rightValue = wheelPicker.numbers[wheelPicker.selectedRow(inComponent: 1)]
        leftValue = wheelPicker.numbers[wheelPicker.selectedRow(inComponent: 0)]
        print("L:" + "\(leftValue)" + ",R:" + "\(rightValue)" + ",N:" + "\(needlePosition)")
        
    }
}
