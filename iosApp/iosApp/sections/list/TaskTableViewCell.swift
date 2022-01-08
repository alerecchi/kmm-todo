//
//  TaskTableViewCell.swift
//  iosApp
//
//  Created by feanor on 08/01/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import UIKit
import Injector

private typealias ExecuteAction = (TaskListAction) -> Void

final class TaskTableViewCell: UITableViewCell {

	private var dateFormatter: DateFormatter?
	private var currentViewModel: TaskViewModel?
	private var executeAction: ExecuteAction?

	@IBOutlet weak var checkmarkImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		dateFormatter = try? Injector.shared.resolve(DateFormatter.self)
		checkmarkImageView.isUserInteractionEnabled = true

		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		checkmarkImageView.addGestureRecognizer(tapRecognizer)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		checkmarkImageView.image = nil
		titleLabel.attributedText = nil
		dateLabel.attributedText = nil
		currentViewModel = nil
		executeAction = nil
	}

	@objc func tap() {
		guard let currentViewModel = currentViewModel else {
			return
		}

		executeAction?(.toggle(currentViewModel))
	}

	func configure(_ viewModel: TaskViewModel, executeAction: @escaping (TaskListAction) -> Void) {
		checkmarkImageView.image = viewModel.completed ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")

		accessoryType = viewModel.completed ? .none : .disclosureIndicator

		let titleLabelAttributes: [NSAttributedString.Key : Any] = viewModel.completed ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]

		var dateLabelAttributes: [NSAttributedString.Key : Any] = titleLabelAttributes

		if viewModel.expired {
			dateLabelAttributes[.foregroundColor] = UIColor.systemRed
		}

		titleLabel.attributedText = NSAttributedString(string: viewModel.title, attributes: titleLabelAttributes)
		dateLabel.attributedText = NSAttributedString(string: format(date: viewModel.date) ?? "", attributes: dateLabelAttributes)

		currentViewModel = viewModel
		self.executeAction = executeAction
	}

	// MARK: Private methods

	private func format(date: Date?) -> String? {
		guard let date = date else {
			return nil
		}

		return dateFormatter?.string(from: date)
	}

}
