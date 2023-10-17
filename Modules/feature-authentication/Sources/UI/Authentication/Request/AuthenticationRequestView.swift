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
import logic_ui
import logic_resources

public struct AuthenticationRequestView<Router: RouterHostType, Interactor: AuthenticationInteractorType>: View {

  @ObservedObject var viewModel: AuthenticationRequestViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)
  }

  public var body: some View {
    ContentScreen(errorConfig: viewModel.viewState.error) {

      ContentHeader(
        dismissIcon: ThemeManager.shared.image.xmark,
        onBack: { viewModel.onPop() }
      )

      ContentTitle(
        title: viewModel.viewState.title
      )

      VSpacer.extraSmall()

      HStack {

        Text("\(Text(viewModel.viewState.caption)) \(Text(viewModel.viewState.dataRequestInfo).underline())")
          .typography(ThemeManager.shared.font.bodyMedium)
          .foregroundColor(ThemeManager.shared.color.textSecondaryDark)
          .onTapGesture { viewModel.onShowRequestInfoModal() }

        Spacer()

        visibilityIcon
      }

      Spacer()

      footer
    }
    .sheetDialog(isPresented: $viewModel.isCancelModalShowing) {
      VStack(spacing: SPACING_MEDIUM) {

        ContentTitle(
          title: .cancelShareSheetTitle,
          caption: .cancelShareSheetCaption
        )

        WrapButtonView(style: .primary, title: .cancelShareSheetContinue, onAction: viewModel.onShowCancelModal())
        WrapButtonView(style: .secondary, title: .cancelButton, onAction: viewModel.onPop())
      }
    }
    .sheetDialog(isPresented: $viewModel.isRequestInfoModalShowing) {
      VStack(spacing: SPACING_MEDIUM) {

        ContentTitle(
          title: .requestDataInfoNotice,
          caption: .requestDataSheetCaption
        )

        WrapButtonView(style: .primary, title: .okButton, onAction: viewModel.onShowRequestInfoModal())
      }
    }
  }

  var visibilityIcon: some View {

    let image = switch viewModel.viewState.isContentVisible {
    case true:
      ThemeManager.shared.image.eye
    case false:
      ThemeManager.shared.image.eyeSlash
    }

    return image
      .foregroundStyle(ThemeManager.shared.color.primary)
      .onTapGesture {
        viewModel.onContentVisibilityChange()
      }
  }

  var footer: some View {
    VStack(spacing: SPACING_MEDIUM) {
      WrapButtonView(style: .primary, title: .shareButton, onAction: viewModel.onShare())
      WrapButtonView(style: .secondary, title: .cancelButton, onAction: viewModel.onShowCancelModal())
    }
  }
}
