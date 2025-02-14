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
import logic_resources

public extension View {
  func confirmationDialog(
    title: LocalizableString.Key,
    message: LocalizableString.Key,
    destructiveText: LocalizableString.Key? = nil,
    baseText: LocalizableString.Key,
    isPresented: Binding<Bool>,
    destructiveAction: (() -> Void)? = nil,
    baseAction: @escaping () -> Void
  ) -> some View {
    self.modifier(
      ConfirmationDialogModifier(
        title: title,
        message: message,
        destructiveText: destructiveText,
        baseText: baseText,
        isPresented: isPresented,
        destructiveAction: destructiveAction,
        baseAction: baseAction
      )
    )
  }
}

struct ConfirmationDialogModifier: ViewModifier {
  let title: LocalizableString.Key
  let message: LocalizableString.Key
  let destructiveText: LocalizableString.Key?
  let baseText: LocalizableString.Key
  let isPresented: Binding<Bool>
  let destructiveAction: (() -> Void)?
  let baseAction: () -> Void

  func body(content: Content) -> some View {
    content
      .confirmationDialog(
        title,
        isPresented: isPresented,
        titleVisibility: .visible
      ) {
        if let destructiveText = destructiveText, let destructiveAction = destructiveAction {
          Button(destructiveText, role: .destructive) {
            destructiveAction()
          }
        }
        Button(baseText, role: .cancel) {
          baseAction()
        }
      } message: {
        Text(message)
      }
  }
}
