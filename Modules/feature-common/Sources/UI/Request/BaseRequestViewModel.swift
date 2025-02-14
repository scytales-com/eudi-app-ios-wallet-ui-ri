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

@_exported import logic_ui
@_exported import logic_resources

@Copyable
public struct RequestViewState: ViewState {
  public let isLoading: Bool
  public let error: ContentErrorView.Config?
  public let showMissingCrredentials: Bool
  public let items: [RequestDataUI]
  public let trustedRelyingPartyInfo: LocalizableString.Key
  public let relyingParty: LocalizableString.Key
  public let isTrusted: Bool
  public let allowShare: Bool
  public let originator: AppRoute
  public let initialized: Bool
  public let contentHeaderConfig: ContentHeaderConfig
}

open class BaseRequestViewModel<Router: RouterHost>: ViewModel<Router, RequestViewState> {

  @Published var isRequestInfoModalShowing: Bool = false
  @Published var isVerifiedEntityModalShowing: Bool = false
  @Published var itmesChanged: Bool = false

  public init(router: Router, originator: AppRoute) {
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        error: nil,
        showMissingCrredentials: true,
        items: RequestDataUiModel.mockData(),
        trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
        relyingParty: .unknownVerifier,
        isTrusted: false,
        allowShare: false,
        originator: originator,
        initialized: false,
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          ),
          description: .dataSharingTitle
        )
      )
    )
  }

  open func doWork() async {}

  open func getTitle() -> LocalizableString.Key {
    return .custom("")
  }

  open func getRelyingParty() -> LocalizableString.Key {
    return .custom("")
  }

  open func getRelyingPartyIsTrusted() -> Bool {
    return false
  }

  open func getCaption() -> LocalizableString.Key {
    return .custom("")
  }

  open func getDataRequestInfo() -> LocalizableString.Key {
    return .custom("")
  }

  open func getSuccessRoute() -> AppRoute? {
    return nil
  }

  open func getTitleCaption() -> String {
    return ""
  }

  open func getTrustedRelyingParty() -> LocalizableString.Key {
    return .custom("")
  }

  open func getTrustedRelyingPartyInfo() -> LocalizableString.Key {
    return .custom("")
  }

  open func onShare() {
    guard let route = getSuccessRoute() else { return }
    router.push(with: route)
  }

  open func getPopRoute() -> AppRoute? {
    return nil
  }

  public func getOriginator() -> AppRoute {
    return viewState.originator
  }

  public func onStartLoading() {
    setState {
      $0.copy(isLoading: true).copy(error: nil)
    }
  }

  public func onError(with error: Error) {
    setState {
      $0.copy(
        isLoading: false,
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.router.pop(),
          action: { self.onErrorAction() }
        )
      )
    }
  }

  public func onEmptyDocuments() {
    setState {
      $0.copy(
        isLoading: false,
        items: [],
        initialized: true
      ).copy(error: nil)
    }
  }

  public func onReceivedItems(
    with items: [RequestDataUI],
    title: LocalizableString.Key,
    relyingParty: LocalizableString.Key,
    isTrusted: Bool
  ) {
    setState {
      $0.copy(
        isLoading: false,
        items: items,
        relyingParty: relyingParty,
        isTrusted: isTrusted,
        allowShare: canShare(with: items),
        initialized: true
      )
      .copy(error: nil)
    }
  }

  public func resetState() {
    setState { previous in
      .init(
        isLoading: true,
        error: nil,
        showMissingCrredentials: true,
        items: RequestDataUiModel.mockData(),
        trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
        relyingParty: .unknownVerifier,
        isTrusted: false,
        allowShare: false,
        originator: previous.originator,
        initialized: false,
        contentHeaderConfig: initialHeaderConfig()
      )
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [
        Action(
          title: .shareButton,
          disabled: !viewState.allowShare
        ) {
          self.onShare()
        }
      ],
      leadingActions: [
        Action(
          image: Theme.shared.image.chevronLeft) {
            self.onPop()
          }
      ]
    )
  }

  func onPop() {
    isRequestInfoModalShowing = false
    if let route = getPopRoute() {
      router.popTo(with: route)
    } else {
      router.pop()
    }
  }

  func onShowRequestInfoModal() {
    isRequestInfoModalShowing = !isRequestInfoModalShowing
  }

  func onVerifiedEntityModal() {
    isVerifiedEntityModalShowing = !isVerifiedEntityModalShowing
  }

  func onSelectionChanged(id: String) async {
    if viewState.showMissingCrredentials {
      itmesChanged = true

      setState {
        $0.copy(
          showMissingCrredentials: false
        )
      }
    } else {
      let items = viewState.items.map { item in
        var updatedItem = item
        updatedItem.toggleSelection(id: id)
        return updatedItem
      }

      setState {
        $0.copy(
          showMissingCrredentials: false,
          items: items,
          allowShare: canShare(with: items)
        )
      }
    }
  }

  private func initialHeaderConfig() -> ContentHeaderConfig {
    .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      ),
      description: .dataSharingTitle
    )
  }

  private func canShare(with items: [RequestDataUI]) -> Bool {
    items.canShare()
  }

  private func onErrorAction() {
    setState {
      $0
        .copy(isLoading: false)
        .copy(error: nil)
    }
    Task {
      await self.doWork()
    }
  }
}
