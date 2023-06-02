//
//  TaskCell.swift
//  Todolist
//
//  Created by Bhavi on 01/06/23.
//

import RxSwift
import UIKit

class TaskCell: UITableViewCell, BasicSetupType {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var btnDelete: UIButton!
    var bag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpText()
        setUpViews()
    }

    func setUpText() {}

    func setUpViews() {
        btnCheck.setImage(Asset.Assets.icUncheck.image, for: .normal)
        btnCheck.setImage(Asset.Assets.icChecked.image, for: .selected)
        btnDelete.setImage(Asset.Assets.icClose.image, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func config(task: ToDolist?) {
        guard let task = task else {
            return
        }

        lblTitle.attributedText = (task.status == .completed) ? task.task_title?.strikeThrough() : NSAttributedString(string: task.task_title ?? "")
        lblSubTitle.isHidden = task.status != .exceed
        lblSubTitle.text = task.status.title
        lblTime.text = task.task_end_date?.toString(format: DateFormat.time_ampm)
        btnCheck.isSelected = (task.status == .completed)
        btnCheck.isEnabled = (task.status != .completed)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
