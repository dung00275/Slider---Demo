//
//  SliderCustomWalletView.swift
//  SlideDemo
//
//  Created by Dung Vu on 5/13/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

public enum Status: CustomStringConvertible {
    case Off,
    OnChange,
    On
    
    public var description: String {
        switch self {
        case .Off:
            return "Off Wallet"
        case .OnChange:
            return "Wallet Changing"
        case .On:
            return "On Wallet"
        }
    }
}

@IBDesignable
public class SliderCustomWalletView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidthView: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidthThumb: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorThumb: UIColor? = UIColor.yellowColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorTextThumb: UIColor? = UIColor.blackColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var widthThumb: CGFloat = 200 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var textOnThumb: String = "test" {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorTextBackground: UIColor? = UIColor.whiteColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var fontSizeTextBackground: CGFloat = 25 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    public var status = Status.Off
    
    private var thumb: UILabel!
    private var widthConstraintThumb: NSLayoutConstraint!
    private var textLayer: TextLayerCustom!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        setupTextLayer()
        
        if thumb == nil {
            thumb = UILabel(frame: CGRectZero)
        }
        thumb.text = textOnThumb
        thumb.textAlignment = .Center
        setLayerValue(thumb.layer,
                      borderWidth: borderWidthThumb)
        thumb.backgroundColor = colorThumb
        thumb.textColor = colorTextThumb
        thumb.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumb)
        
        thumb.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        thumb.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        thumb.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        widthConstraintThumb = thumb.widthAnchor.constraintEqualToConstant(widthThumb)
        
        widthConstraintThumb.active = true
        
    }
    
    private func setupTextLayer(){
        textLayer = TextLayerCustom()
        textLayer.frame = self.bounds
        textLayer.string = status.description
        textLayer.foregroundColor = colorTextBackground?.CGColor
        textLayer.alignmentMode = "center"
        textLayer.fontSize = fontSizeTextBackground
        textLayer.shouldRasterize = true
        self.layer.addSublayer(textLayer)
    }
    
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        textLayer.frame = self.bounds
        textLayer.foregroundColor = colorTextBackground?.CGColor
        textLayer.fontSize = fontSizeTextBackground
        setLayerValue(layer, borderWidth: borderWidthView)
        setLayerValue(thumb.layer, borderWidth: borderWidthThumb)
        textLayer.frame = self.bounds
        thumb.text = textOnThumb
        thumb.backgroundColor = colorThumb
        thumb.textColor = colorTextThumb
        widthConstraintThumb.constant = widthThumb
        self.layoutIfNeeded()
    }
    
    private func setLayerValue(layer: CALayer, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
    }
    
}

class TextLayerCustom: CATextLayer {
    override func drawInContext(ctx: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height - fontSize) / 2 - fontSize/10
        
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, 0.0, yDiff)
        super.drawInContext(ctx)
        CGContextRestoreGState(ctx)
    }
}
