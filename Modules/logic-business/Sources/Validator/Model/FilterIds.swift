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
public struct FilterIds {
  public static let ASCENDING_DESCENDING_GROUP = "ascending_descending_group"
  public static let ORDER_BY_ASCENDING = "order_by_ascending"
  public static let ORDER_BY_DESCENDING = "order_by_descending"
  public static let FILTER_BY_STATE_GROUP_ID = "state_group_id"
  public static let FILTER_BY_STATE_VALID = "state_valid"
  public static let FILTER_BY_STATE_EXPIRED = "state_expired"
  public static let FILTER_BY_DOCUMENT_CATEGORY_GROUP_ID = "category_group_id"
  public static let FILTER_BY_ISSUER_GROUP_ID = "issuer_group_id"
  public static let FILTER_BY_PERIOD_GROUP_ID = "by_period_group_id"
  public static let FILTER_BY_PERIOD_DEFAULT = "by_period_default"
  public static let FILTER_BY_PERIOD_NEXT_7 = "by_period_next_7"
  public static let FILTER_BY_PERIOD_NEXT_30 = "by_period_next_30"
  public static let FILTER_BY_PERIOD_BEYOND_30 = "by_period_beyond_30"
  public static let FILTER_BY_PERIOD_EXPIRED = "by_period_expired"
  public static let FILTER_SORT_GROUP_ID = "sort_group_id"
  public static let FILTER_SORT_DEFAULT = "sort_default"
  public static let FILTER_SORT_DATE_ISSUED = "sort_date_issued"
  public static let FILTER_SORT_EXPIRY_DATE = "sort_expiry_date"
}
