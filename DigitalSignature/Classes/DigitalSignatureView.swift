//
//  DigitalSignatureView.swift
//  DigitalSignature
//
//  Created by Nguyễn Thanh Bình on 4/6/24.
//

import UIKit

@IBDesignable
public class DigitalSignatureView: UIView {
//    enum Spec {
//        static let brushColor = UIColor.green
//        static var brushWidth: CGFloat = 10.0
//        static var opacity: CGFloat = 1.0
//    }
    @IBInspectable var brushColor = UIColor.black
    @IBInspectable var brushWidth: CGFloat = 1
    @IBInspectable var opacity: CGFloat = 1
    public var image: UIImage? {
        get {
            return self.maskImgv.image
        }
    }
    
    public func clear() {
        self.maskImgv.image = nil
    }
    
    private var lastPoint = CGPoint.zero
        
    private var maskImgv = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.lastPoint = touch.location(in: self)
        }
    }
    
    private func setup() {
        self.addSubview(self.maskImgv)
        self.maskImgv.translatesAutoresizingMaskIntoConstraints = false
        self.maskImgv.backgroundColor = .white
        NSLayoutConstraint.activate([
            self.maskImgv.topAnchor.constraint(equalTo: self.topAnchor),
            self.maskImgv.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.maskImgv.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.maskImgv.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
        
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {

        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.maskImgv.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))

        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)

        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(self.brushWidth)
        context?.setStrokeColor(self.brushColor.cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()


        self.maskImgv.image = UIGraphicsGetImageFromCurrentImageContext()
        self.maskImgv.alpha = self.opacity
        UIGraphicsEndImageContext()
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            self.drawLineFrom(fromPoint: self.lastPoint, toPoint: currentPoint)
            self.lastPoint = currentPoint
        }
    }
}
