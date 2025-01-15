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

public protocol ImageManagerProtocol: Sendable {
  var logo: Image { get }
  var faceId: Image { get }
  var id: Image { get }
  var idStroke: Image { get }
  var nfc: Image { get }
  var touchId: Image { get }
  var user: Image { get }
  var arrowLeft: Image { get }
  var chevronUp: Image { get }
  var chevronDown: Image { get }
  var chevronRight: Image { get }
  var chevronLeft: Image { get }
  var xmark: Image { get }
  var exclamationmarkCircle: Image { get }
  var circle: Image { get }
  var eye: Image { get }
  var eyeSlash: Image { get }
  var checkmarkCircleFill: Image { get }
  var checkmarkSquareFill: Image { get }
  var square: Image { get }
  var exclamationmarkOctagon: Image { get }
  var plus: Image { get }
  var share: Image { get }
  var warning: Image { get }
  var checkMarkSealFill: Image { get }
  var more: Image { get }
  var pencil: Image { get }
  var qrScan: Image { get }
  var photo: Image { get }
  var trash: Image { get }
  var bluetoothConnect: Image { get }
  var viewFinder: Image { get }
  var message: Image { get }
  var clock: Image { get }
  var clockIndicator: Image { get }
  var errorIndicator: Image { get }
  var signDocument: Image { get }
  var euditext: Image { get }
  var walletVerified: Image { get }
  var congradulationsDocument: Image { get }
  var bell: Image { get }
  var menuIcon: Image { get }
  var filterMenuIcon: Image { get }
  var bookmarkIcon: Image { get }
  var bookmarkIconFill: Image { get }
  var gearshape: Image { get }
  var checkmark: Image { get }
  var hourglassImage: Image { get }
  var boltIcon: Image { get }
  var chooseDocumentImage: Image { get }
  var scanDocumentImage: Image { get }
  var infoCircle: Image { get }
  var relyingPartyVerified: Image { get }
  var houseFill: Image { get }
  var docFill: Image { get }
  var arrowLeftArrowRight: Image { get }
  var logoEuDigitalIndentityWallet: Image { get }
  var homeContract: Image { get }
  var homeIdentity: Image { get }
  var issuerCardImagePlaceholder: Image { get }
  var successSecuredWallet: Image { get }
  var digitalIdIssuance: Image { get }
  var documentSuccessPending: Image { get }
  var govLogo: Image { get }
}

final class ImageManager: ImageManagerProtocol {

  enum ImageEnum: String {
    case faceId = "face-id"
    case id = "id"
    case idStroke = "id-stroke"
    case nfc = "nfc"
    case touchId = "touch-id"
    case user = "user"
    case logo = "logo"
    case arrowLeft = "arrow.left"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case chevronRight = "chevron.right"
    case chevronLeft = "chevron.left"
    case xmark = "xmark"
    case exclamationmarkCircle = "exclamationmark.circle"
    case circle = "circle.fill"
    case eye = "eye"
    case eyeSlash = "eye.slash"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case checkmarkSquareFill = "checkmark.square.fill"
    case square = "square"
    case exclamationmarkOctagon = "exclamationmark.octagon"
    case plus = "plus"
    case share = "square.and.arrow.up"
    case warning = "ic-warning"
    case checkMarkSealFill = "checkmark.seal.fill"
    case more = "ic-more"
    case pencil = "ic-edit"
    case qrScan = "ic-qr-scanner"
    case photo = "photo.fill"
    case trash = "trash"
    case bluetoothConnect = "bluetooth-connect"
    case viewFinder = "viewfinder"
    case message = "ic-message"
    case clock = "ic-clock"
    case clockIndicator = "ic-clock-indicator"
    case errorIndicator = "ic-error-indicator"
    case signDocument = "doc"
    case euditext = "EUDI-text"
    case walletVerified = "wallet-verified"
    case congradulationsDocument = "congradulations-document"
    case bell
    case menuIcon = "menu-icon"
    case filterMenuIcon = "filter-menu-icon"
    case bookmarkIcon = "bookmark"
    case bookmarkIconFill = "bookmark.fill"
    case gearshape
    case checkmark
    case hourglassImage
    case boltIcon = "bolt-icon"
    case chooseDocumentImage = "choose-document-image"
    case scanDocumentImage = "scan-document-image"
    case infoCircle = "info.circle"
    case relyingPartyVerified = "relying-party-verified"
    case houseFill = "house.fill"
    case docFill = "doc.fill"
    case arrowLeftArrowRight = "arrow.left.arrow.right"
    case logoEuDigitalIndentityWallet = "logo-eu-digital-indentity-wallet"
    case homeContract = "home-contract"
    case homeIdentity = "home-identity"
    case issuerCardImagePlaceholder = "issuer-card-image-placeholder"
    case successSecuredWallet = "success-secured-wallet"
    case digitalIdIssuance = "digital-id-issuance"
    case documentSuccessPending = "document-success-pending"
    case govLogo = "gov-logo"
  }

  // MARK: - Properties

  let bundle: Bundle
  // MARK: - Lifecycle

  init(bundle: Bundle) {
    self.bundle = bundle
  }
  // MARK: - Images
  var faceId: Image {
    Image(ImageEnum.faceId.rawValue, bundle: bundle)
  }
  var id: Image {
    Image(ImageEnum.id.rawValue, bundle: bundle)
  }
  var idStroke: Image {
    Image(ImageEnum.idStroke.rawValue, bundle: bundle)
  }
  var nfc: Image {
    Image(ImageEnum.nfc.rawValue, bundle: bundle)
  }
  var touchId: Image {
    Image(ImageEnum.touchId.rawValue, bundle: bundle)
  }
  var user: Image {
    Image(ImageEnum.user.rawValue, bundle: bundle)
  }
  var logo: Image {
    Image(ImageEnum.logo.rawValue, bundle: bundle)
  }
  var arrowLeft: Image {
    Image(systemName: ImageEnum.arrowLeft.rawValue)
  }
  var chevronUp: Image {
    Image(systemName: ImageEnum.chevronUp.rawValue)
  }
  var chevronDown: Image {
    Image(systemName: ImageEnum.chevronDown.rawValue)
  }
  var chevronRight: Image {
    Image(systemName: ImageEnum.chevronRight.rawValue)
  }
  var chevronLeft: Image {
    Image(systemName: ImageEnum.chevronLeft.rawValue)
  }
  var xmark: Image {
    Image(systemName: ImageEnum.xmark.rawValue)
  }
  var exclamationmarkCircle: Image {
    Image(systemName: ImageEnum.exclamationmarkCircle.rawValue)
  }
  var circle: Image {
    Image(systemName: ImageEnum.circle.rawValue)
  }
  var eye: Image {
    Image(systemName: ImageEnum.eye.rawValue)
  }
  var eyeSlash: Image {
    Image(systemName: ImageEnum.eyeSlash.rawValue)
  }
  var checkmarkCircleFill: Image {
    Image(systemName: ImageEnum.checkmarkCircleFill.rawValue)
  }
  var checkmarkSquareFill: Image {
    Image(systemName: ImageEnum.checkmarkSquareFill.rawValue)
  }
  var square: Image {
    Image(systemName: ImageEnum.square.rawValue)
  }
  var exclamationmarkOctagon: Image {
    Image(systemName: ImageEnum.exclamationmarkOctagon.rawValue)
  }
  var plus: Image {
    Image(ImageEnum.plus.rawValue, bundle: bundle)
  }
  var share: Image {
    Image(systemName: ImageEnum.share.rawValue)
  }
  var warning: Image {
    Image(ImageEnum.warning.rawValue, bundle: bundle)
  }
  var checkMarkSealFill: Image {
    Image(systemName: ImageEnum.checkMarkSealFill.rawValue)
  }
  var more: Image {
    Image(ImageEnum.more.rawValue, bundle: bundle)
  }
  var pencil: Image {
    Image(ImageEnum.pencil.rawValue, bundle: bundle)
  }
  var qrScan: Image {
    Image(ImageEnum.qrScan.rawValue, bundle: bundle)
  }
  var photo: Image {
    Image(systemName: ImageEnum.photo.rawValue)
  }
  var trash: Image {
    Image(systemName: ImageEnum.trash.rawValue)
  }
  var bluetoothConnect: Image {
    Image(ImageEnum.bluetoothConnect.rawValue, bundle: bundle)
  }
  var viewFinder: Image {
    Image(systemName: ImageEnum.viewFinder.rawValue)
  }
  var message: Image {
    Image(ImageEnum.message.rawValue, bundle: bundle)
  }
  var clock: Image {
    Image(ImageEnum.clock.rawValue, bundle: bundle)
  }
  var clockIndicator: Image {
    Image(ImageEnum.clockIndicator.rawValue, bundle: bundle)
  }
  var errorIndicator: Image {
    Image(ImageEnum.errorIndicator.rawValue, bundle: bundle)
  }
  var signDocument: Image {
    Image(systemName: ImageEnum.signDocument.rawValue)
  }
  var euditext: Image {
    Image(ImageEnum.euditext.rawValue, bundle: bundle)
  }
  var walletVerified: Image {
    Image(ImageEnum.walletVerified.rawValue, bundle: bundle)
  }
  var congradulationsDocument: Image {
    Image(ImageEnum.congradulationsDocument.rawValue, bundle: bundle)
  }
  var bell: Image {
    Image(systemName: ImageEnum.bell.rawValue)
  }
  var menuIcon: Image {
    Image(ImageEnum.menuIcon.rawValue, bundle: bundle)
  }
  var filterMenuIcon: Image {
    Image(ImageEnum.filterMenuIcon.rawValue, bundle: bundle)
  }
  var bookmarkIcon: Image {
    Image(systemName: ImageEnum.bookmarkIcon.rawValue)
  }
  var bookmarkIconFill: Image {
    Image(systemName: ImageEnum.bookmarkIconFill.rawValue)
  }
  var gearshape: Image {
    Image(systemName: ImageEnum.gearshape.rawValue)
  }
  var checkmark: Image {
    Image(systemName: ImageEnum.checkmark.rawValue)
  }
  var hourglassImage: Image {
    Image(ImageEnum.hourglassImage.rawValue, bundle: bundle)
  }
  var boltIcon: Image {
    Image(ImageEnum.boltIcon.rawValue, bundle: bundle)
  }
  var chooseDocumentImage: Image {
    Image(ImageEnum.chooseDocumentImage.rawValue, bundle: bundle)
  }
  var scanDocumentImage: Image {
    Image(ImageEnum.scanDocumentImage.rawValue, bundle: bundle)
  }
  var infoCircle: Image {
    Image(systemName: ImageEnum.infoCircle.rawValue)
  }
  var relyingPartyVerified: Image {
    Image(ImageEnum.relyingPartyVerified.rawValue, bundle: bundle)
  }
  var houseFill: Image {
    Image(systemName: ImageEnum.houseFill.rawValue)
  }
  var docFill: Image {
    Image(systemName: ImageEnum.docFill.rawValue)
  }
  var arrowLeftArrowRight: Image {
    Image(systemName: ImageEnum.arrowLeftArrowRight.rawValue)
  }
  var logoEuDigitalIndentityWallet: Image {
    Image(ImageEnum.logoEuDigitalIndentityWallet.rawValue, bundle: bundle)
  }
  var homeContract: Image {
    Image(ImageEnum.homeContract.rawValue, bundle: bundle)
  }
  var homeIdentity: Image {
    Image(ImageEnum.homeIdentity.rawValue, bundle: bundle)
  }
  var issuerCardImagePlaceholder: Image {
    Image(ImageEnum.issuerCardImagePlaceholder.rawValue, bundle: bundle)
  }
  var successSecuredWallet: Image {
    Image(ImageEnum.successSecuredWallet.rawValue, bundle: bundle)
  }
  var digitalIdIssuance: Image {
    Image(ImageEnum.digitalIdIssuance.rawValue, bundle: bundle)
  }
  var documentSuccessPending: Image {
    Image(ImageEnum.documentSuccessPending.rawValue, bundle: bundle)
  }
  var govLogo: Image {
    Image(ImageEnum.govLogo.rawValue, bundle: bundle)
  }
}
