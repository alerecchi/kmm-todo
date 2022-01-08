//
//  AddTaskViewModel.swift
//  iosApp
//
//  Created by feanor on 08/01/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import shared
import Combine
import Foundation

enum TaskDetailsState: Equatable {
	case loading
	case create(pageTitle: String)
	case edit(pageTitle: String, taskTitle: String, taskDate: String)
}

enum TaskDetailsAction: Equatable {
	case goBack
}

final class TaskDetailViewModel: Observer {

	private let stateMachine: shared.TaskDetailsStateMachine
	private let stateSubject: CurrentValueSubject<TaskDetailsState, Never>
	private let actionSubject: PassthroughSubject<TaskDetailsAction, Never>

	var state: AnyPublisher<TaskDetailsState, Never> {
		stateSubject.removeDuplicates().receive(on: RunLoop.main).eraseToAnyPublisher()
	}

	var action: AnyPublisher<TaskDetailsAction, Never> {
		actionSubject.removeDuplicates().receive(on: RunLoop.main).eraseToAnyPublisher()
	}

	init(stateMachine: shared.TaskDetailsStateMachine) {
		self.stateMachine = stateMachine
		stateSubject = CurrentValueSubject(.loading)
		actionSubject = PassthroughSubject()
	}

	func bind() {
		stateMachine.register(observer: self)
	}

	func unbind() {
		stateMachine.unRegister(observer: self)
	}

	func loadTask(_ id: Int64?) {

		let kotlinId: KotlinLong? = id != nil ? KotlinLong(longLong: id!) : nil

		stateMachine.handleAction(action: shared.TaskDetailsAction.LoadTask(id: kotlinId)) { _, _ in

		}
	}

	func save(title: String, date: String) {

		stateMachine.handleAction(action: shared.TaskDetailsAction.InsertTask(title: title, date: date)) { _, _ in

		}
	}

	func update(id: Int64, title: String, date: String) {
		stateMachine.handleAction(action: shared.TaskDetailsAction.UpdateTask(id: id, title: title, date: date)) { _, _ in

		}
	}


	func updateState(state: Any?) {
		switch state {
		case _ as shared.TaskDetailsState.Loading:
			break
		case _ as shared.TaskDetailsState.PageLoaded:
			stateSubject.send(.create(pageTitle: "Add task"))
		case let taskLoaded as shared.TaskDetailsState.TaskLoaded:
			stateSubject.send(.edit(pageTitle: "Edit task", taskTitle: taskLoaded.title, taskDate: taskLoaded.date))
		case _ as shared.TaskDetailsState.BackNavigation:
			actionSubject.send(.goBack)
		default:
			break
		}
	}
}
