import CoreData
import EmptyDataSet_Swift
import RxSwift
import UIKit
class BaseTableController: BaseController {
    var refreshController = UIRefreshControl()
    var onNewRowAdded = PublishSubject<Void>()
    var onLoadMore = PublishSubject<Void>()
    var blockOperations = [BlockOperation]()
    var insertAnimation = UITableView.RowAnimation.fade
    var deleteAnimation = UITableView.RowAnimation.fade
    var updateAnimation = UITableView.RowAnimation.fade
    var moveAnimation = UITableView.RowAnimation.fade
    var onRefreshDataFinish = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configureRefreshData() {
        onRefreshDataFinish.subscribe(onNext: { [weak self] _ in
            self?.emptyDataSetHandler?.setUpEmptyData()
        }).disposed(by: disposeBag)
    }

    func onRefreshTrigger() -> Observable<Void> {
        let emptyButtonTrigger = emptyDataSetHandler?.onButtonClick.asObserver() ?? Observable.empty()
        return Observable.merge([emptyButtonTrigger, refreshController.rx.controlEvent(.valueChanged).asObservable()])
    }

    func emptyButtonAction() -> Observable<Void> {
        let emptyButtonTrigger = emptyDataSetHandler?.onSingleOperationClick.asObserver() ?? Observable.empty()
        return Observable.merge([emptyButtonTrigger])
    }

    func pullReferesh() -> Observable<Void> {
        return Observable.merge([refreshController.rx.controlEvent(.valueChanged).asObservable()])
    }

    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = fetchController?.sections,
           indexPath.section < sections.count {
            if indexPath.row < sections[indexPath.section].numberOfObjects {
                return true
            }
        }
        return false
    }

    override func setupFetchController(model: String, sortDesc: [NSSortDescriptor], section: String? = nil, predicate: NSPredicate? = nil, context: NSManagedObjectContext = Config.db_context) {
        super.setupFetchController(model: model, sortDesc: sortDesc, section: section, predicate: predicate, context: context)
        fetchController?.delegate = self
    }
}

extension BaseTableController: UITableViewDelegate {
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return fetchController?.sections?.count ?? 0
    }

    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let s = fetchController?.sections {
            return s[section].numberOfObjects
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension BaseTableController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange object: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        let op: BlockOperation

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            op = BlockOperation { self.tableView.insertRows(at: [newIndexPath],
                                                            with: self.insertAnimation)
                self.onNewRowAdded.onNext(())
            }
            op.name = "insert"

        case .delete:
            guard let indexPath = indexPath else { return }
            op = BlockOperation { self.tableView.deleteRows(at: [indexPath],
                                                            with: self.deleteAnimation) }

            op.name = "delete"

        case .update:
            guard let indexPath = indexPath else { return }
            op = BlockOperation { self.tableView.reloadRows(at: [indexPath],
                                                            with: self.updateAnimation) }

            op.name = "update"

        case .move:

            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            op = BlockOperation {
                self.tableView.deleteRows(at: [indexPath],
                                          with: self.moveAnimation)
                self.tableView.insertRows(at: [newIndexPath],
                                          with: self.moveAnimation)
            }
            op.name = "move"

        @unknown default:
            return
        }
        blockOperations.append(op)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        let op: BlockOperation

        switch type {
        case .insert:
            op = BlockOperation {
                self.tableView.insertSections(IndexSet(integer: sectionIndex),
                                              with: UITableView.RowAnimation.none)
            }

        case .delete:
            op = BlockOperation {
                self.tableView.deleteSections(IndexSet(integer: sectionIndex),
                                              with: UITableView.RowAnimation.none)
            }

        case .move:
            return
        case .update:
            return
        @unknown default:
            return
        }
        blockOperations.append(op)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(controller.fetchRequest.entityName)
        tableView?.performBatchUpdates({
            self.blockOperations.forEach { $0.start() }
        }, completion: { _ in
            self.onRefreshDataFinish.onNext(())
            self.blockOperations.removeAll()
        })
    }
}
