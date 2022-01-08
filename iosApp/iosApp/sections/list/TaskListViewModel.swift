//
//  TaskListViewModel.swift
//  iosApp
//
//  Created by feanor on 07/01/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import shared
import Combine
import Foundation

struct TaskViewModel: Hashable {
	let id: Int64
	let title: String
	let completed: Bool
	let date: Date?

	var canDelete: Bool { completed }

	var expired: Bool {
		guard let date = date else {
			return false
		}

		return date < Date()
	}

	var canSelect: Bool { !canDelete }
}

private extension Task {
	var asTaskViewModel: TaskViewModel {
		var dateComponents = DateComponents()
		dateComponents.day = Int(date.dayOfMonth)
		dateComponents.month = Int(date.monthNumber)
		dateComponents.year = Int(date.year)

		return TaskViewModel(
			id: id,
			title: title,
			completed: completed,
			date: Calendar.current.date(from: dateComponents)
		)
	}
}

private extension TaskViewModel {
	var asTask: Task {
		Task(id: id, title: title, completed: completed, date: Kotlinx_datetimeLocalDate(year: 1, monthNumber: 1, dayOfMonth: 1))
	}
}

enum TaskListState: Equatable {
	case loading
	case taskList([TaskViewModel])
}

enum TaskListAction: Equatable {
	case add
	case load
	case modify(id: Int64)
	case toggle(TaskViewModel)
	case delete(id: Int64)
}

final class TaskListViewModel: Observer {

	private let taskListStateMachine: TaskListStateMachine
	private let currentStateSubject: CurrentValueSubject<TaskListState, Never>
	private let actionSubject: PassthroughSubject<TaskListAction, Never>

	var state: AnyPublisher<TaskListState, Never> {
		currentStateSubject.removeDuplicates().receive(on: RunLoop.main).eraseToAnyPublisher()
	}

	var action: AnyPublisher<TaskListAction, Never> {
		actionSubject.receive(on: RunLoop.main).eraseToAnyPublisher()
	}

	init(taskListStateMachine: TaskListStateMachine) {
		self.taskListStateMachine = taskListStateMachine
		currentStateSubject = CurrentValueSubject(.loading)
		actionSubject = PassthroughSubject()
	}

	func bind() {
		taskListStateMachine.register(observer: self)
	}

	func unbind() {
		taskListStateMachine.unRegister(observer: self)
	}

	func perform(_ action: TaskListAction) {
		switch action {
		case .load:
			loadTasks()
		case .add:
			addTask()
		case .modify(let id):
			openTask(id)
		case .toggle(let taskViewModel):
			toggle(taskViewModel)
		case .delete(let id):
			delete(id)
		}
	}

	// MARK: Observer
	func updateState(state: Any?) {
		switch state {
		case _ as shared.TaskListState.Loading:
			break
		case let taskList as shared.TaskListState.ShowList:
			currentStateSubject.send(.taskList(taskList.tasks.map({$0.asTaskViewModel})))
		case let navigate as shared.TaskListState.NavigateToDetails where navigate.id == nil:
			actionSubject.send(.add)
		case let navigate as shared.TaskListState.NavigateToDetails where navigate.id != nil:
			actionSubject.send(.modify(id: navigate.id!.int64Value))
		default:
			break
		}
	}

	// MARK: Private methods

	private func loadTasks() {
		taskListStateMachine.handleAction(action: shared.TaskListAction.LoadTasks()) { _, _ in
			print("load")
		}
	}

	private func addTask() {
		taskListStateMachine.handleAction(action: shared.TaskListAction.AddTask()) { _, _ in
			print("add")
		}
	}

	private func openTask(_ id: Int64) {
		taskListStateMachine.handleAction(action: shared.TaskListAction.ModifyTask(id: id)) { _, _ in
			print("open")
		}
	}

	private func toggle(_ viewModel: TaskViewModel) {
		taskListStateMachine.handleAction(action: shared.TaskListAction.ToggleTask(task: viewModel.asTask)) { _, _ in
			print("toggle")
		}
	}

	private func delete(_ id: Int64) {
		taskListStateMachine.handleAction(action: shared.TaskListAction.DeleteTask(id: id)) { _, _ in
			print("delete")
		}
	}
	
}
