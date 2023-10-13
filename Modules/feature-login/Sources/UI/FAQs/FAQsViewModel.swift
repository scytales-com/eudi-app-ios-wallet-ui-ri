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
import Foundation
import logic_ui

/*
 public struct FAQDisplayable {
   

   init(
     isLoading: Bool = true,
     searchText: String = "",
     models: [FAQUIModel] = [],
     filteredModels: [FAQUIModel] = []
   ) {
     self.isLoading = isLoading
     self.searchText = searchText
     self.models = models
     self.filteredModels = filteredModels
   }
 }
 */
struct FAQState: ViewState {
  let isLoading: Bool
  let searchText: String
  let models: [FAQUIModel]
  let filteredModels: [FAQUIModel]
}

@MainActor
final class FAQsViewModel<Router: RouterHostType, Interactor: FAQsInteractorType>: BaseViewModel<Router, FAQState> {

  private let interactor: Interactor
  @Published var searchText = ""

  init(router: Router, interactor: Interactor) {
    self.interactor = interactor

    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        searchText: "",
        models: FAQUIModel.mocks(),
        filteredModels: FAQUIModel.mocks()
      )
    )

    subscribeToSearchedText()
  }

  private func subscribeToSearchedText() {
    $searchText
      .dropFirst()
      .map { [weak self] text -> [FAQUIModel] in
        guard let self = self else { return [] }
        return viewState.models.filter { model in
          return text.isEmpty || model.value.title.localizedCaseInsensitiveContains(text)
        }
      }
      .sink(receiveValue: { [weak self] models in
        guard let self = self else { return }
        self.setNewState(
          filteredModels: models
        )
      })
      .store(in: &cancellables)
  }

  func fetchFAQs() async {

    defer {
      setNewState(
        isLoading: false
      )
    }

    do {
      setNewState(
        isLoading: true,
        models: try await interactor.fetchFAQs()
      )
    } catch {
      setNewState(
        isLoading: false,
        models: []
      )
    }
  }

  func goBack() {
    router.pop(animated: true)
  }

  private func setNewState(
    isLoading: Bool? = nil,
    searchText: String? = nil,
    models: [FAQUIModel]? = nil,
    filteredModels: [FAQUIModel]? = nil
  ) {
    setState { previousState in
      .init(
        isLoading: isLoading ?? previousState.isLoading,
        searchText: searchText ?? previousState.searchText,
        models: models ?? previousState.models,
        filteredModels: filteredModels ?? previousState.filteredModels
      )
    }
  }
}
