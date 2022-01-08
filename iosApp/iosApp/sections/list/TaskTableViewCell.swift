//
//  TaskTableViewCell.swift
//  iosApp
//
//  Created by feanor on 08/01/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import UIKit
import Injector

final class TaskTableViewCell: UITableViewCell {

	private var dateFormatter: DateFormatter?

	@IBOutlet weak var checkmarkImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		dateFormatter = try? Injector.shared.resolve(DateFormatter.self)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		checkmarkImageView.image = nil
		titleLabel.text = nil
		dateLabel.text = nil
	}

	func configure(_ viewModel: TaskViewModel) {
		checkmarkImageView.image = viewModel.completed ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")

		accessoryType = viewModel.completed ? .none : .disclosureIndicator

		titleLabel.text = viewModel.title
		dateLabel.text = format(date: viewModel.date)
	}

	// MARK: Private methods

	private func format(date: Date?) -> String? {
		guard let date = date else {
			return nil
		}

		return dateFormatter?.string(from: date)
	}

}
