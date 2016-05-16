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

// MARK: --- Class SliderCustomWalletView
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
    
    // MARK: --- Border Thumb
    @IBInspectable var borderWidthThumb: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderThumbColor: UIColor? = UIColor.clearColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // MARK: - Shadow
    @IBInspectable var shadowColor: UIColor? = UIColor.blackColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffsetX: CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffsetY: CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 0.5 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    public var status = Status.Off {
        didSet {
            textLayer.string = status.description
        }
    }
    
    private var thumb: ThumbView!
    private var widthConstraintThumb: NSLayoutConstraint!
    private var textLayer: TextLayerCustom!
    private var leftThumConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: --- Common Init
    private func commonInit() {
        setupTextLayer()
        if thumb == nil {
            thumb = ThumbView(frame: CGRectZero)
        }
        
        
        setLayerValue(layer,
                      borderWidth: borderWidthView)
        
        thumb.text = textOnThumb
        thumb.text = textOnThumb
        thumb.cornerRadius = cornerRadius
        thumb.colorBackground = colorThumb
        thumb.colorText = colorTextThumb
        
        thumb.shadowOpacity = shadowOpacity
        thumb.shadowOffsetY = shadowOffsetY
        thumb.shadowOffsetX = shadowOffsetX
        
        thumb.shadowRadius = shadowRadius
        thumb.shadowColor = shadowColor
        
        thumb.borderWidthThumb = borderWidthThumb
        thumb.borderColor = borderThumbColor
        
        thumb.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumb)
        
        
        thumb.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        leftThumConstraint = thumb.leftAnchor.constraintEqualToAnchor(self.leftAnchor)
        leftThumConstraint.active = true
        thumb.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        widthConstraintThumb = thumb.widthAnchor.constraintEqualToConstant(widthThumb)
        
        widthConstraintThumb.active = true
        
        setupGesture()
        
    }
    
    
    // MARK: --- Setup text layer
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
    
    // MARK: --- Drawrect
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        textLayer.frame = self.bounds
        textLayer.foregroundColor = colorTextBackground?.CGColor
        textLayer.fontSize = fontSizeTextBackground
        
        setLayerValue(layer, borderWidth: borderWidthView)
    
        textLayer.frame = self.bounds
        
        thumb.cornerRadius = cornerRadius
        thumb.text = textOnThumb
        thumb.colorBackground = colorThumb
        thumb.colorText = colorTextThumb
        
        thumb.shadowOpacity = shadowOpacity
        thumb.shadowOffsetY = shadowOffsetY
        thumb.shadowOffsetX = shadowOffsetX
        
        thumb.shadowRadius = shadowRadius
        thumb.shadowColor = shadowColor
        
        thumb.borderWidthThumb = borderWidthThumb
        thumb.borderColor = borderThumbColor
        
        widthConstraintThumb.constant = widthThumb
        self.layoutIfNeeded()
    }
    
    // MARK: --- Helper
    private func setLayerValue(layer: CALayer, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
    }
    
    
    // MARK: --- Gesture
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SliderCustomWalletView.gestureValueChange))
        thumb.addGestureRecognizer(panGesture)
    }
    
    
    public func gestureValueChange(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self)
        print("Translation  : \(translation.x)")
        
        switch gesture.state {
        case .Changed:
            defer {
                gesture.setTranslation(CGPointZero, inView: gesture.view)
            }
            if leftThumConstraint.constant + translation.x + widthThumb >= self.bounds.width{
                status = .On
            }else if leftThumConstraint.constant +  translation.x + widthThumb <= 0 {
                status = .Off
            }else {
                status = .OnChange
                
            }
            leftThumConstraint.constant += translation.x
            
        case .Ended, .Cancelled:
            var valueEnd: CGFloat = 0
            if leftThumConstraint.constant + widthThumb >= CGRectGetMidX(self.bounds) {
                status = Status.On
                valueEnd = self.bounds.width - widthThumb
            } else {
                status = Status.Off
            }
            
            UIView.animateWithDuration(0.2, animations: {
                self.leftThumConstraint.constant = valueEnd
                self.layoutIfNeeded()
                }, completion: nil)
            
        default:
            break
        }
        
    }
    
    
}


// MARK: --- Class ThumbView
@IBDesignable
class ThumbView:UIView {
    
    // MARK:--- Corner
    @IBInspectable var cornerRadius: CGFloat = 6 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorBackground: UIColor? = UIColor.yellowColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var text: String = "test" {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorText: UIColor? = UIColor.whiteColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // MARK: --- Border
    @IBInspectable var borderWidthThumb: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor? = UIColor.clearColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // MARK: --- Shadow
    @IBInspectable var shadowColor: UIColor? = UIColor.blackColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffsetX: CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffsetY: CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 0.5 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        self.backgroundColor = UIColor.clearColor()
        
        if label == nil {
            label = UILabel(frame: CGRectZero)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(label)
            
            label.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
            label.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
            label.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
            label.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
            
        }
        
        label.textAlignment = .Center
        label.backgroundColor = colorBackground
        
        label.layer.cornerRadius = cornerRadius
        label.layer.masksToBounds = true
        
        label.text = text
        label.textColor = colorText
        
        label.layer.borderWidth = borderWidthThumb
        label.layer.borderColor = borderColor?.CGColor
        
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        label.backgroundColor = colorBackground
        label.layer.cornerRadius = cornerRadius
        label.layer.borderWidth = borderWidthThumb
        label.layer.borderColor = borderColor?.CGColor
        
        label.text = text
        label.textColor = colorText
        
        
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOffset = CGSizeMake(shadowOffsetX, shadowOffsetY)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = Float(shadowOpacity)
    }
    
    
}


// MARK: --- TextLayerCustom
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
