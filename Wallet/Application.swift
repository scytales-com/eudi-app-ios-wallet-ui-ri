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
import SwiftUI
import logic_ui
import logic_navigation
import logic_resources
import logic_business
import PartialSheet

@main
struct Application: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @Environment(\.scenePhase) var scenePhase

  @State var isScreenCapping: Bool = false
  @State var blurType: BlurType = .none
  @State var shouldAddBottomPadding: Bool = false
  @State var toolbarConfig: UIConfig.ToolBar = .init(Theme.shared.color.backgroundPaper)

  private let routerHost: RouterHostType
  private let configUiLogic: ConfigUiLogic
  private let securityController: SecurityControllerType
  private let deepLinkController: DeepLinkControllerType

  init() {
    self.routerHost = RouterHost()
    self.configUiLogic = ConfigUiProvider.shared.getConfigUiLogic()
    self.securityController = SecurityController()
    self.deepLinkController = DeepLinkController()
    self.toolbarConfig = routerHost.getToolbarConfig()
  }

  var body: some Scene {
    WindowGroup {
      ZStack {

        Rectangle()
          .fill(toolbarConfig.backgroundColor)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)
          .animation(
            .easeIn(duration: UINavigationController.hideShowBarDuration),
            value: toolbarConfig.backgroundColor
          )

        routerHost.composeApplication()
          .if(self.shouldAddBottomPadding == false) {
            $0.ignoresSafeArea(edges: .bottom)
          }
          .attachPartialSheetToRoot()

        if isScreenCapping {
          warningScreenCap()
        }

        if blurType != .none {
          BlurView(style: .regular)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
        }
      }
      .onOpenURL { url in
        if let deepLink = deepLinkController.hasDeepLink(url: url) {
          deepLinkController.handleDeepLinkAction(
            routerHost: routerHost,
            deepLinkAction: deepLink
          )
        }
      }
      .onChange(of: scenePhase) { phase in
        switch phase {
        case .background:
          self.blurType = .background
        case .inactive:
          self.blurType = .inactive
        case .active:
          self.blurType = .none
        default: break
        }
      }
      .onReceive(NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)) { _ in
        guard self.securityController.isScreenCaptureDisabled() else {
          return
        }
        self.isScreenCapping.toggle()
      }
      .onReceive(NotificationCenter.default.publisher(for: .shouldChangeBackgroundColor), perform: { _ in
        self.toolbarConfig = routerHost.getToolbarConfig()
      })
      .task {
        await checkForHomeIndicator()
      }
    }
  }

  private func warningScreenCap() -> some View {
    ZStack(alignment: .center) {
      VStack(alignment: .center, spacing: SPACING_EXTRA_LARGE) {
        ThemeManager.shared.image.logo
        Text(.screenCaptureSecurityWarning)
          .typography(ThemeManager.shared.font.bodyMedium)
          .foregroundColor(ThemeManager.shared.color.textPrimaryDark)
          .multilineTextAlignment(.center)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeManager.shared.color.backgroundPaper)
    .edgesIgnoringSafeArea(.all)
  }

  private func checkForHomeIndicator() async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    if UIDevice.current.uiHomeIndicator == .unavailable {
      self.shouldAddBottomPadding = true
    }
  }
}

extension Application {
  enum BlurType {
    case inactive
    case background
    case none
  }
}
