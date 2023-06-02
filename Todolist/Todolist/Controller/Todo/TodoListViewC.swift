//
//  TodoListViewC.swift
//  Todolist
//
//  Created by Bhavi on 01/06/23.
//

import UIKit

class TodoListViewC: BaseTableController {
    @IBOutlet var btnAdd: ThemeButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    let barBtnItem = UIBarButtonItem(image: Asset.Assets.icAscendingSort.image, style: .plain, target: nil, action: nil)

    var height: CGFloat = 0.0
    var navH: CGFloat = 0.0
    let padding: CGFloat = 60.0
    var ascending: Bool = true

    var viewModel: TodoTaskViewModelOuptputType = TodoTaskViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpText()
        setUpViews()
        bindData()
        tableSetup()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? AddTaskViewC {
            controller.viewModel.output.objTask = sender as? ToDolist
            controller.operation = (sender is ToDolist) ? .update : .add
            controller.taskAdded.subscribe(onNext: { [weak self] _ in
                self?.performFetch()
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        }
    }
}

extension TodoListViewC: BasicSetupType {
    func setUpText() {
        title = "Task list"
    }

    func setUpViews() {
        navigationItem.rightBarButtonItem = barBtnItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
        navH = topbarHeight
        btnAdd.type = .with(Asset.Assets.icAdd.image)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 2
        height = view.frame.height - navH - padding
        themeSetUp()
    }

    func themeSetUp() {
        setupAccessibility()
    }

    func bindData() {
        emptyDataSetHandler?.setUpEmptyData()
        navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.logoutPopup()
        }).disposed(by: disposeBag)

        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.ascending {
                barBtnItem.image = Asset.Assets.icDecendingSort.image
                self.ascending = false
            } else {
                barBtnItem.image = Asset.Assets.icAscendingSort.image
                self.ascending = true
            }
            sortData(ascending: self.ascending)

        }).disposed(by: disposeBag)

        viewModel.output.onLogout.bind(onNext: { _ in
            UIApplication.setRootView(StoryboardScene.Main.initialScene.instantiate())
        }).disposed(by: disposeBag)

        btnAdd.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            perform(segue: StoryboardSegue.Tasks.segueAddTask, sender: self)
        }).disposed(by: disposeBag)
    }

    func setupAccessibility() {
        tableView.accessibilityIdentifier = "tbl_task"
    }

    func sortData(ascending: Bool) {
        fetchController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: TodoTask.SortType.task_end_date.field, ascending: ascending)]
        performFetch()
        tableView.reloadData()
    }

    func logoutPopup() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let LogoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.viewModel.input.logout()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(LogoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension TodoListViewC: UITableViewDataSource {
    func tableSetup() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 66
        registerCell()
        fetchData()
    }

    func fetchData() {
        setupFetchController(model: ToDolist.entityName()
                             , sortDesc: [NSSortDescriptor(key: "task_end_date", ascending: true)], predicate: NSPredicate(format: "user.uuid = %@ and task_status != %d", AppUser.userId, TaskStatus.delete.rawValue))
    }

    func registerCell() {
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = fetchController?.safeObject(at: indexPath) as? ToDolist
        cell.config(task: task)
        cell.btnCheck.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.viewModel.input.complete(task: task)
        }).disposed(by: cell.bag)
        cell.btnDelete.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.displayConfirmation(task: task)
        }).disposed(by: cell.bag)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        let task = fetchController?.safeObject(at: indexPath) as? ToDolist
        if task?.status != .completed {
            perform(segue: StoryboardSegue.Tasks.segueAddTask, sender: task)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", object is UITableView, let newValue = change?[.newKey], let newSize = newValue as? CGSize {
            if let isEmpty = fetchController?.fetchedObjects?.isEmpty, isEmpty {
                emptyDataSetHandler?.setUpEmptyData()
                bottomConstraint.constant = 70
            } else {
                if newSize.height > height {
                    bottomConstraint.constant = 70
                } else {
                    bottomConstraint.constant = height - newSize.height
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func displayConfirmation(task: ToDolist?) {
        guard let objTask = task, let name = objTask.task_title else { return }

        let title = "Warning"
        let message = "Do you want to delete \"\(name)\", this action can't be undone."

        let alert = CustomAlertController(title: title, message: message) {
            self.viewModel.input.deleteTask(task: task)
        }
        present(alert, animated: true)
    }
}
