import UIKit

class RootViewController: UIViewController {
    private let tabController = LocketTabBarController()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabController.willMove(toParent: self)
        addChild(tabController)
        view.addSubview(tabController.view)
        tabController.didMove(toParent: self)
        tabController.view.frame = view.bounds
        tabController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let secondNavController = LocketNavigationController(rootViewController: PhotoGridViewController())
        tabController.addChild(secondNavController)
    }
}
