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

final class TaskDetailViewModel: Observer {

	private let stateMachine: shared.TaskDetailsStateMachine
	private let stateSubject: CurrentValueSubject<TaskDetailsState, Never>

	init(stateMachine: shared.TaskDetailsStateMachine) {
		self.stateMachine = stateMachine
		stateSubject = CurrentValueSubject(.loading)
	}

	func bind() {
		stateMachine.register(observer: self)
	}

	func unbind() {
		stateMachine.unRegister(observer: self)
	}

	func loadTask(_ id: Int64) {
		stateMachine.handleAction(action: TaskDetailsAction.LoadTask(id: KotlinLong(longLong: id))) { _, _ in

		}
	}

	func updateState(state: Any?) {
		switch state {
		case _ as shared.TaskDetailsState.Loading:
			break
		case let pageLoaded as shared.TaskDetailsState.PageLoaded:
			stateSubject.send(.create(pageTitle: "Add task"))
		case let taskLoaded as shared.TaskDetailsState.TaskLoaded:
			stateSubject.send(.edit(pageTitle: "Edit task", taskTitle: taskLoaded.title, taskDate: taskLoaded.date))
		default:
			break
		}
	}
}
