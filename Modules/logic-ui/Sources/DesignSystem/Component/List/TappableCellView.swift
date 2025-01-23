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

public struct TappableCellView: View {
  public let title: LocalizableString.Key
  public let showDivider: Bool
  public let action: () -> Void

  public init(
    title: LocalizableString.Key,
    showDivider: Bool,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.action = action
    self.showDivider = showDivider
  }

  public var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text(title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.onSurface)
          .lineLimit(1)
          .minimumScaleFactor(0.8)
        Spacer()
        Theme.shared.image.chevronRight
          .foregroundColor(Theme.shared.color.onSurface)
      }
      .padding(Theme.shared.dimension.padding)
      if showDivider {
        Divider()
          .background(Theme.shared.color.onSurface)
          .padding(.horizontal, Theme.shared.dimension.padding)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action()
    }
  }
}
