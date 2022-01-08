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

private typealias Snapshot = NSDiffableDataSourceSnapshot<TaskListSection, TaskViewModel>

private class Datasource: UITableViewDiffableDataSource<TaskListSection, TaskViewModel> {

	private weak var taskListViewModel: TaskListViewModel?

	init(taskListViewModel: TaskListViewModel, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<TaskListSection, TaskViewModel>.CellProvider) {
		self.taskListViewModel = taskListViewModel
		super.init(tableView: tableView, cellProvider: cellProvider)
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		guard let model = itemIdentifier(for: indexPath) else {
			return false
		}

		return model.canDelete
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			guard let model = itemIdentifier(for: indexPath) else {
				return
			}
			taskListViewModel?.perform(.delete(id: model.id))
		default:
			break
		}
	}
}

enum TaskListSection {
	case main
}

final class TaskListViewController: UIViewController, UITableViewDelegate {

	private let viewModel: TaskListViewModel = try! Injector.shared.resolve(TaskListViewModel.self)

	private var cancellables: Set<AnyCancellable> = Set()

	private var dataSource: Datasource?

	private var selectedTaskId: Int64?

	@IBOutlet weak var taskTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		configureTableView()
		observeViewModel()

		title = "Task list"
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		viewModel.perform(.load)
	}

	@IBAction func addTask() {
		viewModel.perform(.add)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let controller = segue.destination as? TaskDetailViewController, let selectedTaskId = selectedTaskId else {
			return
		}

		controller.taskId = selectedTaskId
	}

	// MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selectedItem = dataSource?.itemIdentifier(for: indexPath), selectedItem.canSelect else {
			return
		}

		viewModel.perform(.modify(id: selectedItem.id))
	}

	// MARK: Private methods

	private func observeViewModel() {
		viewModel.bind()
		viewModel.state.sink { [weak self] state in
			switch state {
			case .loading:
				break
			case .taskList(let viewModelsArray) where !viewModelsArray.isEmpty:
				var snapshot = Snapshot()
				snapshot.appendSections([.main])
				snapshot.appendItems(viewModelsArray)
				self?.dataSource?.apply(snapshot, animatingDifferences: true)
			case .taskList(let viewModelsArray) where viewModelsArray.isEmpty:
				guard var snapshot = self?.dataSource?.snapshot() else {
					return
				}
				snapshot.deleteAllItems()
				self?.dataSource?.apply(snapshot, animatingDifferences: true)
			default:
				break
			}
		}.store(in: &cancellables)

		viewModel.action.sink { [weak self] action in
			switch action {
			case .add:
				self?.performSegue(withIdentifier: "add", sender: nil)
			case .modify(let id):
				self?.selectedTaskId = id
				self?.performSegue(withIdentifier: "add", sender: nil)
				break
			default:
				break
			}
		}.store(in: &cancellables)
	}


	private func configureTableView() {
		dataSource = Datasource(taskListViewModel: viewModel, tableView: taskTableView) { [weak self] tableView, indexPath, model in
			let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell
			cell?.configure(model, executeAction: { action in
				self?.viewModel.perform(action)
			})
			return cell
		}

		taskTableView.delegate = self
	}
}
