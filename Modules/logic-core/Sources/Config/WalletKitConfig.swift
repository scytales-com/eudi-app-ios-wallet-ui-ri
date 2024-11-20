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
import logic_business

struct VciConfig: Sendable {
  public let issuerUrl: String
  public let clientId: String
  public let redirectUri: URL
}

struct ReaderConfig: Sendable {
  public let trustedCerts: [Data]
}

protocol WalletKitConfig: Sendable {

  /**
   * VCI Configuration
   */
  var vciConfig: VciConfig { get }

  /**
   * Reader Configuration
   */
  var readerConfig: ReaderConfig { get }

  /**
   * User authentication required accessing core's secure storage
   */
  var userAuthenticationRequired: Bool { get }

  /**
   * Service name for documents key chain storage
   */
  var documentStorageServiceName: String { get }

  /**
   * The name of the file to be created to store logs
   */
  var logFileName: String { get }
}

struct WalletKitConfigImpl: WalletKitConfig {

  let configLogic: ConfigLogic

  init(configLogic: ConfigLogic) {
    self.configLogic = configLogic
  }

  var userAuthenticationRequired: Bool {
    false
  }

  var vciConfig: VciConfig {
    return switch configLogic.appBuildVariant {
    case .DEMO:
        .init(
          issuerUrl: "https://issuer.eudiw.dev",
          clientId: "wallet-dev",
          redirectUri: URL(string: "eu.europa.ec.euidi://authorization")!
        )
    case .DEV:
        .init(
          issuerUrl: "https://dev.issuer.eudiw.dev",
          clientId: "wallet-dev",
          redirectUri: URL(string: "eu.europa.ec.euidi://authorization")!
        )
    }
  }

  var readerConfig: ReaderConfig {
    guard let cert = Data(name: "eudi_pid_issuer_ut", ext: "der") else {
      return .init(trustedCerts: [])
    }
    return .init(trustedCerts: [cert])
  }

  var documentStorageServiceName: String {
    guard let identifier = Bundle.main.bundleIdentifier else {
      return "eudi.document.storage"
    }
    return "\(identifier).eudi.document.storage"
  }

  var logFileName: String {
    return "eudi-ios-wallet-logs"
  }
}
