//
//  ViewModelAssembly.swift
//  iosApp
//
//  Created by feanor on 07/01/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import shared
import Swinject
import Foundation

final class ViewModelAssembly: Assembly {
	func assemble(container: Container) {
		container.register(TaskListViewModel.self) { _ in
			TaskListViewModel(taskListStateMachine: DomainModule().provideStateMachine())
		}

		container.register(TaskDetailViewModel.self) { _ in
			TaskDetailViewModel(stateMachine: DomainModule().provideDetailsStateMachine())
		}
	}
}
