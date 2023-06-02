//
//  CustomAlertController.swift
//  Todolist
//
//  Created by Bhavi on 6/2/23.
//

import UIKit

class CustomAlertController: UIViewController {
    var alertTitle: String = ""
    var alertMessage: String = ""
    var onOkayClosure: (() -> Void)?

    @IBOutlet var contentView: UIView!
    @IBOutlet var alertTitleLabel: UILabel!
    @IBOutlet var alertMessageLabel: UILabel!

    static let nibName: String = {
        String(describing: CustomAlertController.self)
    }()

    convenience init(title: String, message: String, onOkay: @escaping () -> Void = {}) {
        self.init(nibName: String(describing: CustomAlertController.self), bundle: Bundle.main)
        alertTitle = title
        alertMessage = message
        onOkayClosure = onOkay
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        nibBundleOrNil?.loadNibNamed(CustomAlertController.nibName, owner: self, options: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    func setup() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 20

        alertTitleLabel.text = alertTitle
        alertTitleLabel.font = AppFont.regular.size(24, family_Name: roboto)
        alertTitleLabel.textColor = .black
        alertMessageLabel.text = alertMessage
        alertMessageLabel.font = AppFont.regular.size(14, family_Name: roboto)
        alertMessageLabel.textColor = .lightGray
    }

    @IBAction func okPressed(_ sender: UIButton) {
        onOkayClosure?()
        dismiss(animated: true)
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
