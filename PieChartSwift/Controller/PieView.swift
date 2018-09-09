import QuartzCore
import UIKit

class PieView: UIView {
    var sliceValues: [CGFloat] = [] {
        didSet {
            let total = self.sliceValues.reduce(0, +)
            self.normalizedValues = self.sliceValues.map { $0 / total }

            self.updateSlices()
        }
    }

    private var normalizedValues: [CGFloat] = []
    private var containerLayer = CALayer()

    convenience init(sliceValues: [CGFloat]) {
        self.init()
        self.sliceValues = sliceValues
    }

    private func updateSlices() {

        self.containerLayer.frame = bounds

        let currentSlices = (self.containerLayer.sublayers ?? []).map { $0 as! PieSliceLayer }

        // Adjust number of slices
        if self.normalizedValues.count > currentSlices.count {

            let count = normalizedValues.count - currentSlices.count
            for _ in 0 ..< count {
                let slice = PieSliceLayer()
                slice.strokeColor = UIColor(white: 0.25, alpha: 1.0)
                slice.strokeWidth = 0.5
                slice.frame = bounds

                containerLayer.addSublayer(slice)
            }
        } else if self.normalizedValues.count < currentSlices.count {
            let count = currentSlices.count - normalizedValues.count

            for _ in 0 ..< count {
                self.containerLayer.sublayers?.first?.removeFromSuperlayer()
            }
        }

        // Set the angles on the slices
        var startAngle: CGFloat = 0.0
        var index: Int = 0
        let count = CGFloat(normalizedValues.count)
        for num in normalizedValues {
            let angle = num * 2 * .pi

            let slice = containerLayer.sublayers?[index] as! PieSliceLayer
            slice.fillColor = UIColor(hue: CGFloat(index) / count, saturation: 0.5, brightness: 0.75, alpha: 1.0)
            slice.startAngle = startAngle
            slice.endAngle = startAngle + angle

            startAngle += angle
            index += 1
        }
    }


    override func willMove(toSuperview newSuperview: UIView?) {

        let circleLayer = CAShapeLayer()

        let offset = CGPoint(x: (bounds.size.width - 150) / 2, y: (bounds.size.height - 150.0) / 2)
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: offset.x, y: offset.y, width: 150.0, height: 150.0)).cgPath
        circleLayer.fillColor = UIColor.white.cgColor

        layer.addSublayer(containerLayer)
        layer.addSublayer(circleLayer)

    }
}

func DEG2RAD(angle: Double) -> Double {
    return angle * .pi / 180.0
}
