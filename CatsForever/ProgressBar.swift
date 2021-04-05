//
//  ProgressBar.swift
//  CatsForever
//
//  Created by Пользователь on 31.03.2021.
//

import UIKit

class ProgressBar: UIView {
    
    var circularLayer: CAShapeLayer!
    var textLayer: CATextLayer!
    
    var progress: CGFloat = 0 {
        didSet {
            didProgressUpdated()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let widht = rect.width
        let heidht = rect.height
        let lineWidht = 0.1 * min(widht, heidht)
        
        circularLayer = createCircularLayer(rect: rect, strokeColor: UIColor.black.cgColor, fillColor: UIColor.clear.cgColor, lineWight: lineWidht)
        
        textLayer = createTextLayer(rect: rect, textColor: UIColor.black.cgColor)
        
        layer.addSublayer(circularLayer)
        layer.addSublayer(textLayer)
    }
    
    func createCircularLayer(rect: CGRect, strokeColor: CGColor,
                             fillColor: CGColor, lineWight: CGFloat) -> CAShapeLayer {
        
        let widht = rect.width
        let heidht = rect.height
        
        let center = CGPoint(x: widht / 2, y: heidht / 2)
        let radius = (min(widht,heidht) - lineWight) / 2
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWight
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        
        let widht = rect.width
        let height = rect.height
        
        let fontSize = min(widht, height) / 4
        let offset = min(widht, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "10"
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = textColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height - offset - fontSize) / 2, width: widht, height: fontSize + offset)
        layer.alignmentMode = .center
        
        return layer
    }
    
    func didProgressUpdated() {
        textLayer.string = "\(Int (10-(progress * 10)))"
        circularLayer.strokeEnd = progress
    }
}
