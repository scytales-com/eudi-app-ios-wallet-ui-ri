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
import Foundation
import logic_ui
import logic_resources
import feature_common
import logic_business
import logic_core

public protocol DocumentOfferInteractor: Sendable {
  func processOfferRequest(with uri: String) async -> OfferRequestPartialState
  func issueDocuments(
    with uri: String,
    issuerName: String,
    docOffers: [OfferedDocModel],
    successNavigation: UIConfig.TwoWayNavigationType,
    txCodeValue: String?
  ) async -> IssueOfferDocumentsPartialState
  func resumeDynamicIssuance(
    issuerName: String,
    successNavigation: UIConfig.TwoWayNavigationType
  ) async -> OfferDynamicIssuancePartialState

  func getHoldersName(for documentIdentifier: String) -> String?
  func getDocumentSuccessCaption(for documentIdentifier: String) -> LocalizableString.Key?
  func fetchStoredDocuments(documentIds: [String]) async -> DocumentsPartialState
}

final class DocumentOfferInteractorImpl: DocumentOfferInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  func processOfferRequest(with uri: String) async -> OfferRequestPartialState {
    do {

      let codeMinLength = 4
      let codeMaxLength = 6

      let offer = try await walletController.resolveOfferUrlDocTypes(uriOffer: uri)
      let hasPidStored = !walletController.fetchIssuedDocuments(with: [.mDocPid, .sdJwtPid]).isEmpty

      if let spec = offer.txCodeSpec,
         let codeLength = spec.length,
         !(codeMinLength...codeMaxLength).contains(codeLength) || spec.inputMode == .text {
        return .failure(WalletCoreError.transactionCodeFormat(["\(codeMinLength)", "\(codeMaxLength)"]))
      }

      let hasPidInOffer = offer.docModels.first(
        where: { offer in
          let identifier = DocumentTypeIdentifier(rawValue: offer.docType.ifNilOrEmpty { offer.credentialConfigurationIdentifier })
          // MARK: - TODO Re-activate once SD-JWT PID Rule book is in place in ARF.
          // return identifier == .mDocPid || identifier == .sdJwtPid
          return identifier == .mDocPid
        }
      ) != nil

      if !hasPidStored && !hasPidInOffer {
        return .failure(WalletCoreError.missingPid)
      }

      return .success(offer.transformToDocumentOfferUi())
    } catch {
      return .failure(error)
    }
  }

  func issueDocuments(
    with uri: String,
    issuerName: String,
    docOffers: [OfferedDocModel],
    successNavigation: UIConfig.TwoWayNavigationType,
    txCodeValue: String?
  ) async -> IssueOfferDocumentsPartialState {
    do {

      let issuedDocuments = try await walletController.issueDocumentsByOfferUrl(
        offerUri: uri,
        docTypes: docOffers,
        txCodeValue: txCodeValue
      )

      if issuedDocuments.isEmpty {
        return .failure(WalletCoreError.unableToIssueAndStore)
      } else if issuedDocuments.first(where: { $0.isDeferred }) != nil {
        return .deferredSuccess(
          retrieveDeferredRoute(
            caption: .issuanceSuccessDeferredCaption([issuerName]),
            successNavigation: successNavigation,
            title: .init(
              value: .inProgress,
              color: Theme.shared.color.pending
            ),
            buttonTitle: .okButton,
            visualKind: .customIcon(
              Theme.shared.image.documentSuccessPending,
              Color.clear
            )
          )
        )
      } else if let authorizePresentationUrl = issuedDocuments.first?.authorizePresentationUrl {
        guard
          let presentationUrl = authorizePresentationUrl.toCompatibleUrl(),
          let presentationComponents = URLComponents(url: presentationUrl, resolvingAgainstBaseURL: true) else {
          return .failure(WalletCoreError.unableToIssueAndStore)
        }
        let session = await walletController.startSameDevicePresentation(deepLink: presentationComponents)
        return .dynamicIssuance(session)
      } else if issuedDocuments.count == docOffers.count {
        let documentIdentifiers = issuedDocuments.compactMap { $0.id }
        return await fetchAndHandleDocuments(
          successNavigation: successNavigation,
          documentIdentifiers: documentIdentifiers
        )
      } else {

        let documentIdentifiers = issuedDocuments.compactMap { $0.id }
        return await fetchAndHandleDocuments(
          successNavigation: successNavigation,
          documentIdentifiers: documentIdentifiers,
          isPartialState: true
        )
      }

    } catch {
      return .failure(error)
    }
  }

  func resumeDynamicIssuance(
    issuerName: String,
    successNavigation: UIConfig.TwoWayNavigationType
  ) async -> OfferDynamicIssuancePartialState {

    guard let pendingData = await walletController.getDynamicIssuancePendingData() else {
      return .noPending
    }

    do {
      let doc = try await walletController.resumePendingIssuance(
        pendingDoc: pendingData.pendingDoc,
        webUrl: pendingData.url
      )

      if doc.status == .issued {
        let state = await Task.detached { () -> DocumentsPartialState in
          return await self.fetchStoredDocuments(
            documentIds: [doc.id]
          )
        }.value
        switch state {
        case .success(let documents):
            return .success(
              retrieveDocumentSuccessRoute(
                successNavigation: successNavigation,
                documents: documents
              )
            )
        case .failure:
          return .failure(WalletCoreError.unableToIssueAndStore)
        }
      } else if doc.status == .deferred {
        return .success(
          retrieveDeferredRoute(
            caption: .issuanceSuccessDeferredCaption([issuerName]),
            successNavigation: successNavigation,
            title: .init(
              value: .inProgress,
              color: Theme.shared.color.pending
            ),
            buttonTitle: .okButton,
            visualKind: .customIcon(
              Theme.shared.image.documentSuccessPending,
              Color.clear
            )
          )
        )
      } else {
        return .failure(WalletCoreError.unableToIssueAndStore)
      }

    } catch {
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }

  public func getHoldersName(for documentIdentifier: String) -> String? {
    guard
      let bearerName = walletController.fetchDocument(with: documentIdentifier)?.getBearersName()
    else {
      return nil
    }
    return  "\(bearerName.first) \(bearerName.last)"
  }

  public func getDocumentSuccessCaption(for documentIdentifier: String) -> LocalizableString.Key? {
    guard
      let document = walletController.fetchDocument(with: documentIdentifier)
    else {
      return nil
    }
    return .issuanceSuccessCaption([document.displayName.orEmpty])
  }

  func fetchStoredDocuments(documentIds: [String]) async -> DocumentsPartialState {
    let documents = walletController.fetchDocuments(with: documentIds)
    let documentsDetails = documents.compactMap {
      $0.transformToDocumentDetailsUi(isSensitive: false)
    }

    if documentsDetails.isEmpty {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    return .success(documentsDetails)
  }

  private func fetchAndHandleDocuments(
    successNavigation: UIConfig.TwoWayNavigationType,
    documentIdentifiers: [String],
    isPartialState: Bool = false
  ) async -> IssueOfferDocumentsPartialState {
    let state = await Task.detached { () -> DocumentsPartialState in
      return await self.fetchStoredDocuments(
        documentIds: documentIdentifiers
      )
    }.value
    switch state {
    case .success(let documents):
        if isPartialState {
          return .partialSuccess(
            retrieveDocumentSuccessRoute(
              successNavigation: successNavigation,
              documents: documents
            )
          )
        } else {
          return .success(
            retrieveDocumentSuccessRoute(
              successNavigation: successNavigation,
              documents: documents
            )
          )
        }
    case .failure:
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }

  private func retrieveDeferredRoute(
    caption: LocalizableString.Key,
    successNavigation: UIConfig.TwoWayNavigationType,
    title: UIConfig.Success.Title,
    buttonTitle: LocalizableString.Key,
    visualKind: UIConfig.Success.VisualKind
  ) -> AppRoute {
    var navigationType: UIConfig.DeepLinkNavigationType {
      return switch successNavigation {
      case .popTo(let route): .pop(screen: route)
      case .push(let route): .push(screen: route)
      }
    }

    return .featureCommonModule(
      .success(
        config: UIConfig.Success(
          title: title,
          subtitle: caption,
          buttons: [
            .init(
              title: buttonTitle,
              style: .primary,
              navigationType: navigationType
            )
          ],
          visualKind: visualKind
        )
      )
    )
  }

  private func retrieveDocumentSuccessRoute(
    successNavigation: UIConfig.TwoWayNavigationType,
    documents: [DocumentDetailsUIModel]
  ) -> AppRoute {
    var navigationType: UIConfig.DeepLinkNavigationType {
      return switch successNavigation {
      case .popTo(let route): .pop(screen: route)
      case .push(let route): .push(screen: route)
      }
    }

    return .featureIssuanceModule(
      .issuanceSuccess(
        config: DocumentSuccessUIConfig(
          successNavigation: navigationType,
          relyingParty: documents.first?.issuer?.name,
          issuerLogoUrl: documents.first?.issuer?.logoUrl,
          relyingPartyIsTrusted: false
        ),
        requestItems: documents.map { item in
          ListItemSection(
            id: item.id,
            title: item.documentName,
            listItems: item.documentFields
          )
        }
      )
    )
  }
}

public enum OfferRequestPartialState: Sendable {
  case success(DocumentOfferUIModel)
  case failure(Error)
}

public enum IssueOfferDocumentsPartialState: Sendable {
  case success(AppRoute)
  case partialSuccess(AppRoute)
  case deferredSuccess(AppRoute)
  case dynamicIssuance(RemoteSessionCoordinator)
  case failure(Error)
}

public enum OfferDynamicIssuancePartialState: Sendable {
  case success(AppRoute)
  case noPending
  case failure(Error)
}
