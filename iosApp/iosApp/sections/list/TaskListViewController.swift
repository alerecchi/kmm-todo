//
//  TaskListViewController.swift
//  iosApp
//
//  Created by feanor on 07/01/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import UIKit
import Combine
import Injector

private typealias Datasource = UITableViewDiffableDataSource<TaskListSection, TaskViewModel>
private typealias Snapshot = NSDiffableDataSourceSnapshot<TaskListSection, TaskViewModel>

enum TaskListSection {
	case main
}

final class TaskListViewController: UIViewController, UITableViewDelegate {

	private let viewModel: TaskListViewModel = try! Injector.shared.resolve(TaskListViewModel.self)

	private var cancellables: Set<AnyCancellable> = Set()

	private var dataSource: Datasource?

	@IBOutlet weak var taskTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		configureTableView()
		observeViewModel()

		title = "Task list"
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		viewModel.loadTasks()
	}

	@IBAction func addTask() {
		viewModel.addTask()
	}

	// MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selectedItem = dataSource?.itemIdentifier(for: indexPath) else {
			return
		}

		viewModel.openTask(selectedItem.id)
	}

	// MARK: Private methods

	private func observeViewModel() {
		viewModel.bind()
		viewModel.state.sink { [weak self] state in
			switch state {
			case .loading:
				break
			case .taskList(let viewModelsArray):
				var snapshot = Snapshot()
				snapshot.appendSections([.main])
				snapshot.appendItems([TaskViewModel(id: 11, title: "Ciao", completed: true, date: Date())])
				self?.dataSource?.apply(snapshot, animatingDifferences: true)
				break
			}
		}.store(in: &cancellables)

		viewModel.action.sink { [weak self] action in
			switch action {
			case .add:
				self?.performSegue(withIdentifier: "add", sender: nil)
			case .modify:
				break
			}
		}.store(in: &cancellables)
	}

	private func configureTableView() {
		dataSource = UITableViewDiffableDataSource(tableView: taskTableView) { tableView, indexPath, model in
			let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell
			cell?.configure(model)
			return cell
		}

		taskTableView.delegate = self
	}
}
