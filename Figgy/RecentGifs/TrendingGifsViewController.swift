import UIKit

protocol TrendingGifsViewInput: class {
    func insertItems(at indexPaths: [IndexPath])
    func displayError(_ error: String)
}

final class TrendingGifsViewController: UIViewController, TrendingGifsViewInput, StoryboardInstantiable {

    static let storyboardName = "TrendingGifs"

    var output: TrendingGifsViewOutput!

    fileprivate let interitemSpacing: CGFloat = 10
    fileprivate let sectionInsets: CGFloat = 10
    fileprivate let numberOfItemsInRow = 3

    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(ImageCollectionViewCell.self)
        collectionView.register(ActivityIndicatorReusableView.self)
    }
}

extension TrendingGifsViewController {
    func insertItems(at indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
    }

    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: false, completion: nil)
    }
}

extension TrendingGifsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.gifs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeue(at: indexPath)
        let cancel = output.configureCell(at: indexPath) { [weak cell] data in
            cell?.image = data.flatMap(UIImage.init)
        }
        cell.onReuse = cancel

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer: ActivityIndicatorReusableView = collectionView.dequeue(at: indexPath)
        footer.startLoading()

        return footer
    }
}

extension TrendingGifsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = RandomGifBuilder.build(with: output.gifs[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TrendingGifsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        output.collectionScrolled(to: scrollView.contentOffset.y + scrollView.bounds.height,
                                  totalHeight: scrollView.contentSize.height)
    }
}

extension TrendingGifsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = sectionInsets * 2 + interitemSpacing * (CGFloat(numberOfItemsInRow) - 1)
        let width = (collectionView.bounds.width - spacing) / CGFloat(numberOfItemsInRow)

        return CGSize(width: Int(width), height: 150)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionInsets, left: sectionInsets, bottom: sectionInsets, right: sectionInsets)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
