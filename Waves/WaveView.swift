import UIKit
import QuartzCore


private func buildPath(points points: [Int], inBounds bounds: CGRect) -> UIBezierPath? {
    guard points.count >= 2 else { return nil }
    
    guard let maxValue = points.maxElement() where maxValue > 0 else { return nil }
    
    let path = UIBezierPath()
    
    path.moveToPoint(CGPoint(x: 0.0, y: bounds.height))
    
    for (index, point) in points.enumerate() {
        let xProgress = CGFloat(index) / CGFloat(points.count - 1)
        let normalizedValue = CGFloat(point) / CGFloat(maxValue)
        path.addLineToPoint(CGPoint(x: xProgress * bounds.width,
            y: bounds.height * (1.0 - normalizedValue)))
    }
    
    return path
}


public class WaveView: UIView {
    public var points: [Int] = [] { didSet { setNeedsDisplay() } }
    
    private let wave = CAShapeLayer()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        
        tintColorDidChange()
        
        wave.fillColor = nil
        wave.lineWidth = 1.0

        layer.addSublayer(wave)
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        
        wave.strokeColor = self.tintColor.CGColor
    }
    
    public override func drawRect(rect: CGRect) {
        wave.path = buildPath(points: points, inBounds: bounds)?.CGPath
        
        super.drawRect(rect)
    }
    
    public override func layoutSubviews() {
        wave.frame = bounds
        
        super.layoutSubviews()
    }
}
