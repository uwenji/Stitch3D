//
//  ViewController.swift
//  Stitch3D
//
//  Created by You-Wen Ji on 8/31/19.
//  Copyright © 2019 You-Wen Ji. All rights reserved.
//

import UIKit
import Foundation

let buttonX = 100
let buttonWidth:CGFloat = 60
let needleWidth:CGFloat = 200
let velocityPikerWidth = 200

struct Stitchbot: Decodable {
    var id: Int
    var rightVelocity: Int
    var leftVelocity: Int
    var needlePosition: Int
    var stitchON: Int
    public init(id: Int) {
        self.id = 0;
        self.rightVelocity = 0
        self.leftVelocity = 0
        self.needlePosition = 900
        self.stitchON = 0
    }
    public mutating func update(ID: Int, RightVelocity: Int, LeftVelocity: Int, NeedlePosition: Int, StitchON: Int) {
        self.id = ID;
        self.rightVelocity = RightVelocity
        self.leftVelocity = LeftVelocity
        self.needlePosition = NeedlePosition
        self.stitchON = StitchON
    }
}
var bot = Stitchbot(id: 0)

class JoystickController: UIViewController {
    var isStitchON: Int = 0
    let stitchButton: StateButton = {
        let button = StateButton(color: Colors.JFF893B)
        button.setTitle("stitch", for: .normal)
        button.frame = CGRect(x: buttonX, y: buttonX, width: Int(buttonWidth), height: Int(buttonWidth))
        button.layer.cornerRadius = button.frame.size.height / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        button.addTarget(self, action: #selector(StartStitch), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPut(_:)), for: .touchUpInside)
        return button
    }()

    let knotButton: StateButton = {
        let button = StateButton(color: UIColor.systemOrange)
        button.setTitle("stitch", for: .normal)
        button.frame = CGRect(x: buttonX, y: buttonX, width: Int(buttonWidth), height: Int(buttonWidth))
        button.layer.cornerRadius = button.frame.size.height / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        return button
    }()
    
    var rightValue:Int = 0
    var leftValue:Int = 0
    let wheelPicker: VelocityPicker = {
        let picker = VelocityPicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = UIColor.black
        picker.frame = CGRect(x: 100, y: 100, width: 100, height: 200)
        picker.widthAnchor.constraint(equalToConstant: CGFloat(velocityPikerWidth)).isActive = true
        picker.delegate = picker.self
        picker.dataSource = picker.self
        return picker
    }()
    var needlePosition: Int = 0
    let needlePicker: PositionPicker = {
        let picker = PositionPicker(frame:CGRect(x: 0, y: 0, width: 100, height: 210))
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.tintColor = UIColor.systemBackground
//        picker.backgroundColor = Colors.J729CA2
        picker.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 210).isActive = true
        picker.transform = CGAffineTransform(rotationAngle: -.pi * 0.5)
        picker.layer.cornerRadius = buttonWidth * 0.5
        picker.delegate = picker.self
        picker.dataSource = picker.self
        return picker
    }()
    // feedpack and response function
    @objc fileprivate func StartStitch(_ : UIButton) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    //http
    @objc fileprivate func buttonPut(_ sender: Any) {
        isStitchON = stitchButton.currentState
        let parameters = [
            "id": "0",
            "rightVelocity": String(rightValue),
            "leftVelocity": String(leftValue),
            "needlePosition": String(needlePosition),
            "stitchON": String(isStitchON)
        ]
        print("L:" + "\(leftValue)" + ",R:" + "\(rightValue)" + ",N:" + "\(needlePosition)" + ",S:" + "\(isStitchON)")
        
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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = Colors.J1C242B
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        let needleView = UIView()
        let wheelView = UIView()
        
        view.addSubview(needleView)
        view.addSubview(wheelView)
        
        needleView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, top:nil, leading: nil, bottom: nil, trailing: nil, offset: .init(width: 0, height: -100),padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 280, height: buttonWidth))
        wheelView.anchor(centerX: view.centerXAnchor, centerY: nil, top: needleView.bottomAnchor, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 15, left: 0, bottom: 10, right: 0), size: .init(width: 280, height: 200))
        
        //add button and picker
        needleView.addSubview( stitchButton)
        needleView.addSubview( needlePicker)
        stitchButton.trailingAnchor.constraint(equalTo: needleView.trailingAnchor).isActive = true
        needlePicker.centerXAnchor.constraint(equalTo: needleView.centerXAnchor, constant: -35).isActive = true
        needlePicker.centerYAnchor.constraint(equalTo: needleView.centerYAnchor).isActive = true
        
        wheelView.addSubview(wheelPicker)
        wheelPicker.leadingAnchor.constraint(equalTo: wheelView.leadingAnchor).isActive = true

        //animation to set number
        needlePicker.selectRow(91, inComponent: 0, animated: true)
        wheelPicker.selectRow(17, inComponent: 0, animated: true)
        wheelPicker.selectRow(17, inComponent: 1, animated: true)
        //pass the value
        wheelPicker.delegate = self
        wheelPicker.dataSource = self
        
        //graphic
        let circle = UIBezierPath(arcCenter: CGPoint(x: 145, y: 108), radius: CGFloat(Double(abs(rightValue - leftValue)) * 0.2), startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circle.cgPath
        shapeLayer.fillColor = Colors.S465461.cgColor
        
        wheelView.layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    func anchor(centerX:NSLayoutXAxisAnchor?,  centerY:NSLayoutYAxisAnchor?, top:NSLayoutYAxisAnchor? ,leading:NSLayoutXAxisAnchor?, bottom:NSLayoutYAxisAnchor?, trailing:NSLayoutXAxisAnchor? ,offset: CGSize = .zero, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: offset.width).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: offset.height).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading  = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
