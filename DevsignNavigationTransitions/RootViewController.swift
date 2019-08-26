import UIKit

class RootViewController: UIViewController {
    private let tabController = LocketTabBarController()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabController.willMove(toParent: self)
        self.addChild(tabController)
        self.view.addSubview(tabController.view)
        self.tabController.didMove(toParent: self)
        self.tabController.view.frame = self.view.bounds
        self.tabController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let secondNavController = LocketNavigationController(rootViewController: PhotoGridViewController())
        self.tabController.addChild(secondNavController)
    }
}
