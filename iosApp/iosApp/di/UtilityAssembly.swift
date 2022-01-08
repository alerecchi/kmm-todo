//
//  UtilityAssembly.swift
//  iosApp
//
//  Created by feanor on 08/01/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Swinject
import Foundation

final class UtilityAssembly: Assembly {
	func assemble(container: Container) {
		container.register(DateFormatter.self) { _ in
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			return dateFormatter
		}.inObjectScope(.container)
	}
}
