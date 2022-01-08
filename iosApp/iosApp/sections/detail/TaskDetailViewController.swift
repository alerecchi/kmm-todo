//
//  AddTaskViewController.swift
//  iosApp
//
//  Created by feanor on 08/01/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import UIKit
import Combine
import Injector

final class TaskDetailViewController: UIViewController {

	private let viewModel: TaskDetailViewModel = try! Injector.shared.resolve(TaskDetailViewModel.self)

	private var cancellables: Set<AnyCancellable> = Set()


	@IBOutlet weak var taskTitleTextField: UITextField!
	@IBOutlet weak var taskDateTextField: UITextField!

	private var bondTitle: String?
	private var bondDate: String?

	var taskId: Int64?

    override func viewDidLoad() {
        super.viewDidLoad()
		observeViewModel()

		NotificationCenter
			.default
			.publisher(for: UITextField.textDidChangeNotification, object: taskTitleTextField)
			.map({
				($0.object as? UITextField)?.text
			})
			.assign(to: \.bondTitle, on: self)
			.store(in: &cancellables)

		NotificationCenter
			.default
			.publisher(for: UITextField.textDidChangeNotification, object: taskDateTextField)
			.map({
				($0.object as? UITextField)?.text
			})
			.assign(to: \.bondDate, on: self)
			.store(in: &cancellables)
    }


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		viewModel.loadTask(taskId)
	}

	@IBAction func save() {
		guard let title = bondTitle, let date = bondDate else {
			navigationController?.popViewController(animated: true)
			return
		}

		if let currentTaskId = taskId {
			viewModel.update(id: currentTaskId, title: title, date: date)
		} else {
			viewModel.save(title: title, date: date)
		}
	}

	// MARK: Private methods
	private func observeViewModel() {
		viewModel.bind()
		viewModel.state.sink { [weak self] state in
			switch state {
			case .create(pageTitle: let title):
				self?.title = title
			case .edit(pageTitle: let pageTitle, taskTitle: let taskTitle, taskDate: let taskDate):
				self?.title = pageTitle
				self?.bondTitle = taskTitle
				self?.bondDate = taskDate
				self?.taskTitleTextField.text = taskTitle
				self?.taskDateTextField.text = taskDate
			default:
				break
			}
		}.store(in: &cancellables)


		viewModel.action.sink { [weak self] action in
			self?.navigationController?.popViewController(animated: true)
		}.store(in: &cancellables)
	}

}
