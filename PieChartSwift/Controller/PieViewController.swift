import UIKit

class PieViewController: UIViewController {

    @IBOutlet var pieView: PieView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.animatePieSlices()
    }

    @IBAction func animatePieSlices() {
        let count = (1 ... 10).randomElement()!
        self.pieView.sliceValues = (0 ..< count).map { (_) in CGFloat((0 ... 100).randomElement()!) }
    }

}
