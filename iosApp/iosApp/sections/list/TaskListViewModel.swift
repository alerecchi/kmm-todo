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

enum TaskListState: Equatable {
	case loading
	case taskList([TaskViewModel])
}

enum TaskListAction: Equatable {
	case add
	case modify
}

final class TaskListViewModel: Observer {

	private let taskListStateMachine: TaskListStateMachine
	private let currentStateSubject: CurrentValueSubject<TaskListState, Never>
	private let actionSubject: PassthroughSubject<TaskListAction, Never>

	var state: AnyPublisher<TaskListState, Never> {
		currentStateSubject.removeDuplicates().receive(on: RunLoop.main).eraseToAnyPublisher()
	}

	var action: AnyPublisher<TaskListAction, Never> {
		actionSubject.removeDuplicates().receive(on: RunLoop.main).eraseToAnyPublisher()
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

	}

	func loadTasks() {
		taskListStateMachine.handleAction(action: shared.TaskListAction.LoadTasks()) { _, _ in

		}
	}

	func addTask() {
		taskListStateMachine.handleAction(action: shared.TaskListAction.AddTask()) { _, _ in

		}
	}

	func openTask(_ id: Int64) {
		taskListStateMachine.handleAction(action: shared.TaskListAction.ModifyTask(id: id)) { _, _ in

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
			actionSubject.send(.modify)
		default:
			break
		}
	}
	
}
