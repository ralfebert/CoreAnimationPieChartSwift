import QuartzCore
import UIKit

class PieSliceLayer: CALayer {

    @NSManaged var startAngle: CGFloat
    @NSManaged var endAngle: CGFloat
    
    var fillColor = UIColor.gray
    var strokeWidth: CGFloat = 1.0
    var strokeColor = UIColor.black

    static let animatedProperties = Set(["startAngle", "endAngle"])

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func action(forKey key: String) -> CAAction? {
        if PieSliceLayer.animatedProperties.contains(key) {
            return self.makeAnimation(forKey: key)
        }

        return super.action(forKey: key)
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        if self.animatedProperties.contains(key) {
            return true
        }

        return super.needsDisplay(forKey: key)
    }

    func makeAnimation(forKey key: String) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: key)
        animation.fromValue = presentation()?.value(forKey: key)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = 0.5
        return animation
    }

    override init(layer: Any) {
        super.init(layer: layer)

        if let other = layer as? PieSliceLayer {
            self.startAngle = other.startAngle
            self.endAngle = other.endAngle
            self.fillColor = other.fillColor

            self.strokeColor = other.strokeColor
            self.strokeWidth = other.strokeWidth
        }

    }

    override func draw(in ctx: CGContext) {

        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = min(center.x, center.y)

        ctx.beginPath()
        ctx.move(to: CGPoint(x: center.x, y: center.y))

        let p1 = CGPoint(x: center.x + radius * cos(startAngle), y: center.y + radius * sin(startAngle))
        ctx.addLine(to: CGPoint(x: p1.x, y: p1.y))

        let clockwise = startAngle > endAngle
        ctx.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)

        ctx.closePath()

        ctx.setFillColor(fillColor.cgColor)
        ctx.setStrokeColor(strokeColor.cgColor)
        ctx.setLineWidth(strokeWidth)

        ctx.drawPath(using: .fillStroke)
    }
}
