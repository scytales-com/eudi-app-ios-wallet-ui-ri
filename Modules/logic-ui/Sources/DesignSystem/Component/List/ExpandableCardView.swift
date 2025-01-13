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

public struct ExpandableCardView<Content: View>: View {
  private let title: String
  private let subtitle: String
  private let backgroundColor: Color
  private let mainTextVerticalPadding: CGFloat?
  private let content: () -> Content

  public init(
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    title: String,
    subtitle: String,
    mainTextVerticalPadding: CGFloat? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.subtitle = subtitle
    self.backgroundColor = backgroundColor
    self.mainTextVerticalPadding = mainTextVerticalPadding
    self.content = content
  }

  @State private var isExpanded: Bool = false

  public var body: some View {
    VStack(spacing: .zero) {
      WrapCardView(
        backgroundColor: backgroundColor
      ) {
        VStack(spacing: .zero) {
          WrapListItemView(
            listItem: ListItemData(
              mainText: title,
              supportingText: subtitle,
              trailingContent: .icon(isExpanded ? Theme.shared.image.chevronUp : Theme.shared.image.chevronDown)
            ),
            mainTextVerticalPadding: mainTextVerticalPadding
          ) {
            withAnimation {
              isExpanded.toggle()
            }
          }

          if isExpanded {
            content()
          }
        }
      }
    }
  }
}
