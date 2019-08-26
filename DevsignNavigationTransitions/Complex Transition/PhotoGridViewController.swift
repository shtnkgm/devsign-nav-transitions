import Cartography
import Photos
import UIKit

class PhotoGridViewController: UIViewController {
    private let collectionView: UICollectionView
    private let collectionViewLayout: UICollectionViewFlowLayout

    fileprivate var lastSelectedIndexPath: IndexPath?

    private let fetchResult: PHFetchResult<PHAsset>
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate let imageRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        return options
    }()

    init() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoGridCell.self, forCellWithReuseIdentifier: PhotoGridCell.identifier)
        collectionView.alwaysBounceVertical = true
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.invalidateLayout()

        collectionViewLayout = layout
        self.collectionView = collectionView

        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 100
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false),
        ]
        fetchResult = PHAsset.fetchAssets(with: fetchOptions)

        super.init(nibName: nil, bundle: nil)

        title = "Complex"
        tabBarItem.image = UIImage(named: "Complex")

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        collectionView.backgroundColor = .white

        view.addSubview(collectionView)
        constrain(collectionView) {
            $0.edges == $0.superview!.edges
        }
    }
}

extension PhotoGridViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return fetchResult.count
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridCell.identifier, for: indexPath) as! PhotoGridCell
        let asset = fetchResult[indexPath.row]
        cell.asset = asset
        imageManager.requestImage(
            for: asset,
            targetSize: collectionViewLayout.itemSize.pixelSize,
            contentMode: .aspectFill,
            options: imageRequestOptions
        ) { image, _ in
            cell.setImage(image: image, fromAsset: asset)
        }
        return cell
    }
}

extension PhotoGridViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = fetchResult[indexPath.row]
        lastSelectedIndexPath = indexPath
        let photoDetailVC = PhotoDetailViewController(asset: asset)
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoGridCell
        cell.setHighlighted(true)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoGridCell
        cell.setHighlighted(false)
    }
}

extension PhotoGridViewController: PhotoDetailTransitionAnimatorDelegate {
    func transitionWillStart() {
        guard let lastSelected = self.lastSelectedIndexPath else { return }
        collectionView.cellForItem(at: lastSelected)?.isHidden = true
    }

    func transitionDidEnd() {
        guard let lastSelected = self.lastSelectedIndexPath else { return }
        collectionView.cellForItem(at: lastSelected)?.isHidden = false
    }

    func referenceImage() -> UIImage? {
        guard
            let lastSelected = self.lastSelectedIndexPath,
            let cell = self.collectionView.cellForItem(at: lastSelected) as? PhotoGridCell
        else {
            return nil
        }

        return cell.image
    }

    func imageFrame() -> CGRect? {
        guard
            let lastSelected = self.lastSelectedIndexPath,
            let cell = self.collectionView.cellForItem(at: lastSelected)
        else {
            return nil
        }

        return collectionView.convert(cell.frame, to: view)
    }
}
