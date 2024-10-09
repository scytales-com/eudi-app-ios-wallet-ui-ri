/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */

import feature_common

final class ProximityLoadingViewModel<Router: RouterHost>: BaseLoadingViewModel<Router> {

  private let interactor: ProximityInteractor
  private let relyingParty: String

  init(
    router: Router,
    interactor: ProximityInteractor,
    relyingParty: String,
    originator: AppRoute
  ) {
    self.interactor = interactor
    self.relyingParty = relyingParty
    super.init(router: router, originator: originator)

    Task {
      await self.subscribeToCoordinatorPublisher()
    }
  }

  func subscribeToCoordinatorPublisher() async {
    switch self.interactor.getSessionStatePublisher() {
    case .success(let publisher):
      for try await state in publisher {
        switch state {
        case .error(let error):
          self.onError(with: error)
        default:
          ()
        }
      }
    case .failure(let error):
      self.onError(with: error)
    }
  }

  override func getTitle() -> LocalizableString.Key {
    .requestDataTitle([relyingParty])
  }

  override func getCaption() -> LocalizableString.Key {
    .pleaseWait
  }

  private func getOnSuccessRoute() -> AppRoute {
    .featureCommonModule(
      .success(
        config: UIConfig.Success(
          title: .init(value: .success),
          subtitle: .requestDataShareSuccess([relyingParty]),
          buttons: [
            .init(
              title: .okButton,
              style: .primary,
              navigationType: .pop(screen: getOriginator())
            )
          ],
          visualKind: .defaultIcon
        )
      )
    )
  }

  override func getOnPopRoute() -> AppRoute? {
    return switch interactor.getCoordinator() {
    case .success(let proximitySessionCoordinator):
        .featureProximityModule(
          .proximityRequest(
            presentationCoordinator: proximitySessionCoordinator,
            originator: getOriginator()
          )
        )
    case .failure: nil
    }
  }

  override func doWork() async {

    let state = await Task.detached { () -> ProximityResponsePartialState in
      return await self.interactor.onSendResponse()
    }.value

    switch state {
    case .success:
      self.onNavigate(type: .push(getOnSuccessRoute()))
    case .failure(let error):
      self.onError(with: error)
    }
  }
}
