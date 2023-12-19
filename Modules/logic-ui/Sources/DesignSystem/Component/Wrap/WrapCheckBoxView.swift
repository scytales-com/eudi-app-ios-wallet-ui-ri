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
import logic_business

public struct WrapCheckBoxView: View {

  enum Value {
    case string(String)
    case image(Image)
  }

  public typealias TapListener = ((String) -> Void)?

  let isSelected: Bool
  let isVisible: Bool
  let isEnabled: Bool
  let isLoading: Bool
  let id: String
  let title: String
  let value: Value
  let onTap: TapListener

  var checkBoxColor: Color {
    if self.isEnabled {
      ThemeManager.shared.color.primary
    } else {
      ThemeManager.shared.color.textDisabledDark
    }
  }

  var titleTextColor: Color {
    if self.isEnabled {
      ThemeManager.shared.color.textPrimaryDark
    } else {
      ThemeManager.shared.color.textDisabledDark
    }
  }

  public init<T>(
    isSelected: Bool,
    isVisible: Bool,
    isEnabled: Bool,
    isLoading: Bool,
    id: String,
    title: String,
    value: T,
    onTap: TapListener = nil
  ) {
    self.isSelected = isSelected
    self.isVisible = isVisible
    self.isEnabled = isEnabled
    self.isLoading = isLoading
    self.id = id
    self.title = title
    switch value {
    case let value as Data:
      self.value = .image(Theme.shared.image.user)
    case let value as String:
      self.value = .string(value)
    default:
      self.value = .string("")
    }
    self.onTap = onTap
  }

  public var body: some View {

    HStack(spacing: SPACING_SMALL) {

      let image: Image = self.isSelected
      ? ThemeManager.shared.image.checkmarkSquareFill
      : ThemeManager.shared.image.square

      image
        .resizable()
        .scaledToFit()
        .frame(height: 25)
        .foregroundStyle(self.checkBoxColor)

      if !self.isVisible {
        Text(self.title)
          .typography(ThemeManager.shared.font.titleMedium)
          .foregroundStyle(self.titleTextColor)
      } else {
        VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {

          Text(self.title)
            .typography(ThemeManager.shared.font.bodyMedium)
            .foregroundStyle(ThemeManager.shared.color.textSecondaryDark)
          
          switch value {
          case .string(let value):
            Text(value)
              .typography(ThemeManager.shared.font.titleMedium)
              .foregroundStyle(ThemeManager.shared.color.textPrimaryDark)
          case .image(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxHeight: 50)
          }
        }
      }

      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: 50)
    .if(self.onTap != nil && self.isEnabled && !self.isLoading) {
      $0.onTapGesture {
        self.onTap?(self.id)
      }
    }
    .disabled(!self.isEnabled || self.isLoading)
    .shimmer(isLoading: self.isLoading)
    .animation(.easeInOut, value: self.isVisible)
  }
}
