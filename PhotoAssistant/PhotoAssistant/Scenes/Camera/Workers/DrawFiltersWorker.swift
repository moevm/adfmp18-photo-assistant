//
//  DrawFiltersWorker.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 01.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

final class DrawFiltersWorker {
    
    // MARK: - Properties
    
    private let size: CGSize
    private let item: Int
    
    // MARK: - Object Life Cycle
    
    init(size: CGSize,item: Int) {
        self.size = size
        self.item = item
    }
    
    func drawFilter() -> UIImage {
        print(item)
        switch self.item {
        case 0: return drawGrid()
        default: return UIImage()
        }
    }
    
    private func drawGrid() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        context?.setLineWidth(CGFloat(0.5))
        context?.setLineCap(.square)
        context?.setBlendMode(.normal)

        
        func drawFirstVerticalLine() {
            let x = size.width / 3
            let firstPoint = CGPoint(x: x, y: 0)
            let secondPoint = CGPoint(x: x, y: size.height)
            drawLine(from: firstPoint, to: secondPoint)
        }
        
        func drawSecondVerticalLine() {
            let x = 2 * size.width / 3
            let firstPoint = CGPoint(x: x, y: 0)
            let secondPoint = CGPoint(x: x, y: size.height)
            drawLine(from: firstPoint, to: secondPoint)
        }
        
        func drawFirstHorizontalLine() {
            let y = size.height / 3
            let firstPoint = CGPoint(x: 0, y: y)
            let secondPoint = CGPoint(x: size.width, y: y)
            drawLine(from: firstPoint, to: secondPoint)
        }
        
        func drawSecondHorizontalLine() {
            let y = 2 * size.height / 3
            let firstPoint = CGPoint(x: 0, y: y)
            let secondPoint = CGPoint(x: size.width, y: y)
            drawLine(from: firstPoint, to: secondPoint)
        }
        
        func drawLine(from firstPoint: CGPoint,to secondPoint: CGPoint) {
            context?.move(to: firstPoint)
            context?.addLine(to: secondPoint)
        }
        
        drawFirstVerticalLine()
        drawSecondVerticalLine()
        drawFirstHorizontalLine()
        drawSecondHorizontalLine()
        
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    private func drawFibonacciSpiral() {
        
    }
}
