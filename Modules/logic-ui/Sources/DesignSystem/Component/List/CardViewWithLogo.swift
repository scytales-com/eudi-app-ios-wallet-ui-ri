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

public struct CardViewWithLogo: View {
  public let cornerRadius: CGFloat
  public let backgroundColor: Color
  public let icon: Image
  public let title: String
  public let subtitle: String
  public let footer: String
  public let verifiedIcon: Image?
  public let isVerified: Bool

  public init(
    cornerRadius: CGFloat = 13,
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    icon: Image,
    title: String,
    subtitle: String,
    footer: String,
    verifiedIcon: Image? = nil,
    isVerified: Bool = false
  ) {
    self.cornerRadius = cornerRadius
    self.backgroundColor = backgroundColor
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
    self.footer = footer
    self.verifiedIcon = verifiedIcon
    self.isVerified = isVerified
  }

  public var body: some View {
    WrapCardView(backgroundColor: backgroundColor) {
      VStack(alignment: .leading, spacing: 16) {

        HStack {
          icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: .infinity, height: 50)
          Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Text(title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.onSurface)
          .if(isVerified) {
            $0.leftImage(image: Image(systemName: "checkmark"))
          }

        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          Text(footer)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
        }
      }
      .padding(.all, 16)
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    CardViewWithLogo(
      icon: Image(systemName: "building.2.crop.circle.fill")
        .renderingMode(.original),
      title: "Hellenic Government",
      subtitle: "Government agency",
      footer: "Athens - Greece"
    )

    CardViewWithLogo(
      icon: Image(systemName: "building.2.crop.circle.fill"),
      title: "Another Organization",
      subtitle: "Non-Government agency",
      footer: "Athens - Greece"
    )

    CardViewWithLogo(
      backgroundColor: Theme.shared.color.tertiary,
      icon: Image(systemName: "building.2.crop.circle.fill"),
      title: "Another Organization",
      subtitle: "Non-Government agency",
      footer: "Athens - Greece",
      verifiedIcon: Image(systemName: "checkmark"),
      isVerified: true
    )
  }
  .padding()
}
