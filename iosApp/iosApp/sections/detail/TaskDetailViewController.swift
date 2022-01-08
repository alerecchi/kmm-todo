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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
