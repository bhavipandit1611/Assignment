//
//  AddTaskViewC.swift
//  Todolist
//
//  Created by Bhavi on 01/06/23.
//

import RxSwift
import UIKit

class AddTaskViewC: BaseController {
    @IBOutlet var txtTaskTile: TitledTextField!
    @IBOutlet var txtDateTime: TitledTextField!
    @IBOutlet var btnDatePicker: ThemeButton!
    @IBOutlet var btnCancel: ThemeButton!
    @IBOutlet var btnAdd: ThemeButton!
    @IBOutlet var dateView: UIView!

    var viewModel: TodoTaskViewModelOuptputType = TodoTaskViewModel()

    @IBOutlet var datepicker: UIDatePicker!
    let taskAdded = PublishSubject<Bool>()
    var operation: Operation = .add

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpText()
        setUpViews()
        bindData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        taskAdded.onNext(true)
    }
}

extension AddTaskViewC: BasicSetupType {
    func setUpText() {
        title = (operation == .add) ? "Add Task" : "Update Task"
        let btnStr = (operation == .add) ? "ADD" : "UPDATE"
        btnAdd.setTitle(btnStr, for: .normal)
        btnCancel.setTitle("CANCEL", for: .normal)

        txtTaskTile.titleLabelText = "Task Title"
        txtDateTime.titleLabelText = "DateTime"
        setupAccessbilityIds()
    }

    func setUpViews() {
        btnAdd.type = .theme_color(false, 14)
        btnCancel.type = .theme_color(true, 14)
        btnDatePicker.type = .textWith(Asset.Assets.icDatetime.image)
        btnDatePicker.setTitle("", for: .normal)
        txtDateTime.isEnabled = false
        datepicker.minimumDate = Date()

        themeSetUp()
    }

    func themeSetUp() {
    }

    func setupAccessbilityIds() {
        btnAdd.isAccessibilityElement = true
        btnAdd.accessibilityIdentifier = "btnAdd"

        btnDatePicker.isAccessibilityElement = true
        btnDatePicker.accessibilityIdentifier = "btnDatePicker"

        txtTaskTile.isAccessibilityElement = true
        txtTaskTile.accessibilityIdentifier = "txtTaskTile"
        txtDateTime.isAccessibilityElement = true
        txtDateTime.accessibilityIdentifier = "txtDateTime"
    }

    func bindData() {
        txtTaskTile
            .rx.text.orEmpty
            .bind(to: viewModel.output.request.taskTitle)
            .disposed(by: disposeBag)

        txtDateTime
            .rx.text.orEmpty
            .bind(to: viewModel.output.request.dateTime)
            .disposed(by: disposeBag)

        viewModel.output.onResult.bind(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                taskAdded.onNext(true)
                self.backClick(nil)
            case let .failure(err):
                self.alertError(error: err)
            }
        }).disposed(by: disposeBag)

        btnAdd.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            view.endEditing(true)
            if operation == .add {
                viewModel.input.addTask()
            } else {
                viewModel.input.updateTask()
            }
        }).disposed(by: disposeBag)

        btnDatePicker.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dateView.isHidden = !self.dateView.isHidden
            self.handleDateSelection()
        }).disposed(by: disposeBag)

        btnCancel.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            view.endEditing(true)
            self.taskAdded.onNext(true)
            self.backClick(nil)
        }).disposed(by: disposeBag)

        Observable
            .combineLatest(viewModel.output.request.taskTitle, viewModel.output.request.dateTime)
            .map({ $0.isEmpty || $1.isEmpty })
            .bind(to: btnAdd.rx.hk_disableWithAlpha)
            .disposed(by: disposeBag)

        datepicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)

        if operation == .update {
            setupData()
        }
    }
}

extension AddTaskViewC {
    @objc func handleDateSelection() {
        txtDateTime.text = datepicker.date.toString(format: DateFormat.month_date_time_ampm_format)
        if let val = datepicker.date.toString(format: DateFormat.month_date_time_ampm_format) {
            viewModel.output.request.dateTime.accept(val)
        }
    }

    func setupData() {
        guard let objTask = viewModel.output.objTask, let title = objTask.task_title, let dateVal = objTask.task_end_date?.toString(format: DateFormat.month_date_time_ampm_format) else { return }
        txtTaskTile.text = title
        txtDateTime.text = dateVal
        viewModel.output.request.dateTime.accept(dateVal)
        viewModel.output.request.taskTitle.accept(title)
    }
}
