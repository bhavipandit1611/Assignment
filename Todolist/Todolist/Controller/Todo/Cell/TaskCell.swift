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
        btnCheck.setTitle("", for: .normal)
        btnCheck.setImage(Asset.Assets.icChecked.image, for: .highlighted)
        btnDelete.setImage(Asset.Assets.icClose.image, for: .normal)
        btnDelete.setTitle("", for: .normal)
        lblTime.font = AppFont.regular.size(12)
        lblTitle.font = AppFont.regular.size(16)
        lblSubTitle.font = AppFont.regular.size(12)
        lblSubTitle.textColor = Asset.Colors.subtitle.color
        lblTime.textColor = Asset.Colors.time.color
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func config(task: ToDolist?) {
        guard let task = task else {
            return
        }

        lblTitle.attributedText = (task.status == .completed) ? task.task_title?.strikeThrough() : NSAttributedString(string: task.task_title ?? "")
        lblTitle.textColor = (task.status == .completed) ? Asset.Colors.title.color : task.isExceed ? Asset.Colors.red.color : Asset.Colors.title.color
        lblSubTitle.isHidden = (task.status == .completed) ? true : !task.isExceed
        lblSubTitle.text = task.isExceed ? TaskStatus.exceed.title : ""
        lblTime.text = task.task_end_date?.toString(format: DateFormat.month_date_time_ampm_format)
        btnCheck.setSelected(isSelected: task.status == .completed)
        btnCheck.isHighlighted = (task.status == .completed)
        btnCheck.isEnabled = (task.status != .completed)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
