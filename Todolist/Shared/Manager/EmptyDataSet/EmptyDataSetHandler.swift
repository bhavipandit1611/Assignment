import EmptyDataSet_Swift
import Foundation
import RxCocoa
import RxSwift
import UIKit

class EmptyDataSetHandler: EmptyDataSetSource, EmptyDataSetDelegate {
    weak var scrollView: UIScrollView?
    var onButtonClick = PublishSubject<Void>()
    var onSingleOperationClick = PublishSubject<Void>()
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }

    var type: EmptyDataSetType = .no_data

    func setUpEmptyData() {
        let view = scrollView
        view?.emptyDataSetSource = self
        view?.emptyDataSetDelegate = self
        view?.reloadEmptyDataSet()
    }

    func removeEmptyData() {
        scrollView?.emptyDataSetSource = nil
        scrollView?.emptyDataSetDelegate = nil
        scrollView?.reloadEmptyDataSet()
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        if scrollView is UICollectionView {
            return nil
        }
        return type.image
    }

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        if scrollView is UITableView {
            return nil
        }

        return type.title
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return type.desc
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        guard let tableView = scrollView as? UITableView else {
            return 0.0
        }

        let headerHeight = tableView.tableHeaderView?.frame.size.height ?? 0
        //  let footerHeight = footerLoadMoreView?.frame.size.height ?? 0
        return -(headerHeight / 2) + (tableView.superview!.frame.origin.y / 2) - 70
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        onButtonClick.onNext(())
        onSingleOperationClick.onNext(())
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return type.verticalSpace
    }
}
