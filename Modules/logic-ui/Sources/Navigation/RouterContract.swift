/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import SwiftUI

public indirect enum AppRoute: Equatable {

  public static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
    return lhs.key == rhs.key
  }

  case startup
  case faqs

  var key: String {
    switch self {
    case .startup:
      return "Startup"
    case .faqs:
      return "FAQ"
    }
  }
}

public protocol RouterHostType {
  func push(with route: AppRoute)
  func popTo(with route: AppRoute, inclusive: Bool, animated: Bool)
  func pop(animated: Bool)
  func composeApplication() -> AnyView
  func getCurrentScreen() -> AppRoute?
}
