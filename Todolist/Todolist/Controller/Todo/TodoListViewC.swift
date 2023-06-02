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
    var height: CGFloat = 0.0
    var navH: CGFloat = 44.0
    let padding: CGFloat = 40.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        super.viewWillAppear(animated)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? AddTaskViewC {
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
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.Shared.close.image, style: .plain, target: nil, action: nil)
        navH = self.navigationController?.navigationBar.frame.height ?? 50
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
        navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.cancelClick(nil)
        }).disposed(by: disposeBag)

//        interactor?.is_animating.bind(to: rx.hk_isEmptyDataSetHidden).disposed(by: disposeBag)

        btnAdd.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            perform(segue: StoryboardSegue.Tasks.segueAddTask, sender: self)
        }).disposed(by: disposeBag)
    }

    func setupAccessibility() {
        tableView.accessibilityIdentifier = "tbl_task"
    }
}

extension TodoListViewC: UITableViewDataSource {
    func tableSetup() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50
        tableView.hk_setEmptySepratorFooter()
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
            // TODO: Complete Task
        }).disposed(by: cell.bag)

        cell.btnDelete.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            // TODO: Delete
        }).disposed(by: cell.bag)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        let task = fetchController?.safeObject(at: indexPath) as? ToDolist
        // TODO: Update Task
//        if navigateToDetailWithSegue(patient: patient) {
//            perform(segue: StoryboardSegue.Main.seguePatientDetail, sender: fetchController?.safeObject(at: indexPath))
//        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", object is UITableView, let newValue = change?[.newKey], let newSize = newValue as? CGSize {
            if newSize.height > height {
                bottomConstraint.constant = 20
            } else {
                bottomConstraint.constant = height - newSize.height
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
