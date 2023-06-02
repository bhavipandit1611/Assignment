
import CoreData
import EmptyDataSet_Swift
import RxCocoa
import RxSwift
import UIKit

class BaseController: UIViewController, ErrorHandlerProtocol {
    var disposeBag = DisposeBag()
    @IBOutlet var constraintCustomHeightHeader: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView?
    var fetchController: NSFetchedResultsController<NSManagedObject>?
    var onAppBecomeActive = PublishSubject<Notification>()
    var emptyDataSetHandler: EmptyDataSetHandler?

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)

    static let updateSection = PublishSubject<Bool>()
    static let updateProfileInfo = PublishSubject<Bool>()
    static let addedEmployee = PublishSubject<Bool>()
    static let updateOrder = PublishSubject<Bool>()
    static let updateDriverEarn = PublishSubject<Bool>()

    var windowLevel: UIWindow.Level?
    var presentationContext: Context = .independentWindow
    var useInvisibleOverlay: Bool = false

    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppActive()
        overrideUserInterfaceStyle = .light
        activityIndicator.hidesWhenStopped = true
        setUpEmptyDataSet()
    }

    func setUpEmptyDataSet() {
        guard let scrollView = tableView ?? scrollView else {
            return
        }
        emptyDataSetHandler = EmptyDataSetHandler(scrollView: scrollView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setupFetchController(model: String, sortDesc: [NSSortDescriptor], section: String? = nil, predicate: NSPredicate? = nil, context: NSManagedObjectContext = Config.db_context) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: model)
        fetchRequest.sortDescriptors = sortDesc
        fetchRequest.predicate = predicate
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: section, cacheName: nil)

        performFetch()
    }

    func performFetch() {
        do {
            try fetchController?.performFetch()

        } catch {
        }
    }

    func showAlertActivityIndicator(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()

        alert.view.addSubview(activityIndicator)
        alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true

        activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true

        present(alert, animated: true)
    }

    func onError(_ error: ErrorHandler) {
        alertError(error: error)
    }

    func onValidationError(_ error: ValidaterError) {
        alertValidationError(error: error)
    }

    func onCustomError(_ error: ErrorHandler) {}

    func configureAppActive() {
        NotificationCenter.default
            .rx.notification(UIApplication.didBecomeActiveNotification)
            .bind(to: onAppBecomeActive)
            .disposed(by: disposeBag)
    }

    deinit {
        self.nameWithDeinit()
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIViewController {
    func alertError(error: ErrorHandler) {
        let controller = UIAlertController(title: "Error",
                                           message: error.message,
                                           preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }

    func alertValidationError(error: ValidaterError) {
        let controller = UIAlertController(title: "Error",
                                           message: error.message,
                                           preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }

    func alertShow(title: String = Config.app_name,
                   message: String,
                   success: String = "Ok",
                   completion: @escaping (_ action: UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: success, style: .default) { (action: UIAlertAction) in
            completion(action)
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}

enum Context {
    case independentWindow, controllerWindow, controller
}
