//
//  ViewController.swift
//  Stitch3D
//
//  Created by You-Wen Ji on 8/31/19.
//  Copyright © 2019 You-Wen Ji. All rights reserved.
//

import UIKit
import Foundation

let buttonX = 100;
let buttonWidth = 60;

class JoystickController: UIViewController {
    
    let stitchButton: StateButton = {
        let button = StateButton(color: UIColor.systemOrange)
        button.setTitle("stitch", for: .normal)
        button.frame = CGRect(x: buttonX, y: buttonX, width: buttonWidth, height: buttonWidth)
        button.layer.cornerRadius = button.frame.size.height / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        return button
    }()

    let knotButton: StateButton = {
        let button = StateButton(color: UIColor.systemOrange)
        button.setTitle("stitch", for: .normal)
        button.frame = CGRect(x: buttonX, y: buttonX, width: buttonWidth, height: buttonWidth)
        button.layer.cornerRadius = button.frame.size.height / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        return button
    }()
    
    let leftPicker: VelocityPicker = {
        let picker = VelocityPicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = UIColor.black
        picker.frame = CGRect(x: 100, y: 100, width: 20, height: 200)
        picker.widthAnchor.constraint(equalToConstant: 60).isActive = true
        picker.delegate = picker.self
        picker.dataSource = picker.self
        return picker
    }()
    
    let rightPicker: VelocityPicker = {
        let picker = VelocityPicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = UIColor.black
        picker.frame = CGRect(x: 100, y: 200, width: 20, height: 200)
        picker.widthAnchor.constraint(equalToConstant: 60).isActive = true
        picker.delegate = picker.self
        picker.dataSource = picker.self
        return picker
    }()
    
    let needlePicker: PositionPicker = {
        let picker = PositionPicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = UIColor.systemBackground
        picker.backgroundColor = UIColor.systemBlue
        picker.widthAnchor.constraint(equalToConstant: 60).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 120).isActive = true
        picker.transform = CGAffineTransform(rotationAngle: -.pi * 0.5)
        picker.frame = CGRect(x: 100, y: 200, width: 150, height: 400)
//        picker.layer.cornerRadius = picker.frame.width * 0.5
        picker.delegate = picker.self
        picker.dataSource = picker.self
        return picker
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Joystick"
        
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    fileprivate func setupLayout(){
        let titleStackView = UIStackView(arrangedSubviews: [
            needlePicker,
//            knotButton,
            stitchButton
        ])
        titleStackView.distribution = .equalCentering
        titleStackView.spacing = 20
        
        //animation to set number
        needlePicker.selectRow(91, inComponent: 0, animated: true)
        leftPicker.selectRow(17, inComponent: 0, animated: true)
        rightPicker.selectRow(17, inComponent: 0, animated: true)
        let wheelStackView = UIStackView(arrangedSubviews: [
            leftPicker,
            rightPicker
        ])
        
        wheelStackView.distribution = .fillEqually
        wheelStackView.spacing = 40
        
        view.addSubview(titleStackView)
        view.addSubview(wheelStackView)
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive  = true
        //titleStackView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true

//        needlePicker.translatesAutoresizingMaskIntoConstraints = false
//        needlePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        needlePicker.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 55).isActive = true
//        needlePicker.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        needlePicker.heightAnchor.constraint(equalToConstant: 280).isActive = true

        wheelStackView.translatesAutoresizingMaskIntoConstraints = false
        wheelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wheelStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        wheelStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        wheelStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        wheelStackView.widthAnchor.constraint(equalToConstant: 80).isActive = true

    }

}
