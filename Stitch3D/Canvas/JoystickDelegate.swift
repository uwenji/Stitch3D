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
        print("L:" + "\(leftValue)" + ",R:" + "\(rightValue)" + ",N:" + "\(needlePosition)" + ",S:" + "\(isStitchON)")
        
        let parameters = [
            "id": "0",
            "rightVelocity": String(rightValue),
            "leftVelocity": String(leftValue),
            "needlePosition": String(needlePosition),
            "stitchON": String(isStitchON)
        ]
        
        guard let url = URL(string: "http://192.168.10.22/velocity") else{ return}
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{ return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        //        request.allHTTPHeaderFields = headers
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
