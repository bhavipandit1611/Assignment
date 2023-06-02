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

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension AddTaskViewC: BasicSetupType {
    func setUpText() {
        title = (operation == .add) ? "Add Task" : "Update Task"
        let btnStr = (operation == .add) ? "ADD" : "UPDATE"
        btnAdd.setTitle(btnStr, for: .normal)
        btnCancel.setTitle("CANCEL", for: .normal)
        let postfix = Date().toString(format: DateFormat.ampm)
        btnDatePicker.setTitle(postfix, for: .normal)

        txtTaskTile.titleLabelText = "Task Title"
        txtDateTime.titleLabelText = "DateTime"
        setupAccessbilityIds()
    }

    func setUpViews() {
        btnAdd.type = .theme_color(false, 14)
        btnCancel.type = .theme_color(true, 14)
        btnDatePicker.type = .textWith(Asset.Assets.icArrow.image)

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
        viewModel.output.is_animating
            .asDriver()
            .drive(btnAdd.rx.hk_animating)
            .disposed(by: disposeBag)

        viewModel.output.is_animating
            .asDriver()
            .drive(view.rx.hk_userInteraction)
            .disposed(by: disposeBag)

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
                // TODO: Display Alert
                self.alertError(error: err)
            }
        }).disposed(by: disposeBag)

        btnAdd.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            viewModel.input.AddTask()
        }).disposed(by: disposeBag)

        btnDatePicker.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.dateView.isHidden = !self.dateView.isHidden
        }).disposed(by: disposeBag)

        btnCancel.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.backClick(nil)
        }).disposed(by: disposeBag)

        Observable
            .combineLatest(txtDateTime
                .rx.text.orEmpty, txtTaskTile.rx.text.orEmpty)
            .map({ $0.isEmpty || $1.isEmpty })
            .bind(to: btnAdd.rx.hk_disableWithAlpha)
            .disposed(by: disposeBag)

        datepicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
    }
}

extension AddTaskViewC {
    @objc func handleDateSelection() {
        txtDateTime.text = datepicker.date.toString(format: DateFormat.half_month_date_time_ampm_format)
        let postfix = datepicker.date.toString(format: DateFormat.ampm)
        btnDatePicker.setTitle(postfix, for: .normal)
        if let val = datepicker.date.toString(format: DateFormat.month_date_time_ampm_format) {
            viewModel.output.request.date_Time.accept(val)
        }
        view.endEditing(true)
        dateView.isHidden = true
    }
}
