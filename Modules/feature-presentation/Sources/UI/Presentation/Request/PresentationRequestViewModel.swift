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
import logic_core

final class PresentationRequestViewModel<Router: RouterHost>: BaseRequestViewModel<Router> {

  private let interactor: PresentationInteractor

  init(
    router: Router,
    interactor: PresentationInteractor,
    originator: AppRoute
  ) {
    self.interactor = interactor
    super.init(router: router, originator: originator)
  }

  override func doWork() async {
    self.onStartLoading()

    let result = await Task.detached { () -> Result<OnlineAuthenticationRequestSuccessModel, Error> in
      return await self.interactor.onDeviceEngagement()
    }.value

    switch result {
    case .success(let authenticationRequest):
      self.onReceivedItems(
        with: authenticationRequest.requestDataCells,
        title: .requestDataTitle(
          [authenticationRequest.relyingParty]
        ),
        relyingParty: authenticationRequest.relyingParty,
        isTrusted: authenticationRequest.isTrusted
      )
    case .failure:
      self.onEmptyDocuments()
    }
  }

  override func onShare() {
    Task {

      let items = self.viewState.items

      let result = await Task.detached { () -> Result<RequestItemConvertible, Error> in
        return await self.interactor.onResponsePrepare(requestItems: items)
      }.value

      switch result {
      case .success:
        if let route = self.getSuccessRoute() {
          self.router.push(with: route)
        } else {
          self.router.popTo(
            with: self.getPopRoute() ?? .featureDashboardModule(.dashboard)
          )
        }
      case .failure(let error):
        self.onError(with: error)
      }
    }
  }

  override func getSuccessRoute() -> AppRoute? {
    return switch interactor.getCoordinator() {
    case .success(let remoteSessionCoordinator):
        .featureCommonModule(
          .biometry(
            config: UIConfig.Biometry(
              navigationTitle: .biometryConfirmRequest,
              title: getTitle(),
              caption: .requestDataShareBiometryCaption,
              quickPinOnlyCaption: .requestDataShareQuickPinCaption,
              navigationSuccessType: .push(
                .featurePresentationModule(
                  .presentationLoader(
                    getRelyingParty(),
                    presentationCoordinator: remoteSessionCoordinator,
                    originator: getOriginator(),
                    viewState.items.filterSelectedRows()
                  )
                )
              ),
              navigationBackType: .pop,
              isPreAuthorization: false,
              shouldInitializeBiometricOnCreate: true
            )
          )
        )
    case .failure: nil
    }
  }

  override func getPopRoute() -> AppRoute? {
    return getOriginator()
  }

  override func getTitle() -> LocalizableString.Key {
    .dataSharingRequest
  }

  override func getCaption() -> LocalizableString.Key {
    .requestsTheFollowing
  }

  override func getDataRequestInfo() -> LocalizableString.Key {
    .requestDataInfoNotice
  }

  override func getRelyingParty() -> String {
    viewState.relyingParty
  }

  override func getTitleCaption() -> String {
    LocalizableString.shared.get(with: .requestDataTitle([""]))
  }

  override func getTrustedRelyingParty() -> LocalizableString.Key {
    .requestDataVerifiedEntity
  }

  override func getTrustedRelyingPartyInfo() -> LocalizableString.Key {
    .requestDataVerifiedEntityMessage
  }

  func handleDeepLinkNotification(with info: [AnyHashable: Any]) {
    guard let session = info["session"] as? RemoteSessionCoordinator else {
      return
    }
    resetState()
    interactor.updatePresentationCoordinator(with: session)
    Task { await doWork() }
  }
}
