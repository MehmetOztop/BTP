@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZMEHMET_CURRATE'
define root view entity ZR_MEHMET_CURRATE
  as select from zmehmet_currate as Currency_Rates
{
  key cur_id                as CurID,
      //  @Semantics: sort
      @ObjectModel.sort: {enabled: true }
  key cur_date              as CurDate,
//      @UI.dataPoint.valueFormat.scaleFactor: 10000
//      @UI.dataPoint.valueFormat.numberOfFractionalDigits: 5
//      cur_rate              as CurRate,
      cur_rate_value        as CurRateValue,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt

}

// @UI.dataPoint: { qualifier: 'RateData', title: 'Rates',
//    valueFormat: {
//      scaleFactor: 1000,
//         numberOfFractionalDigits: 1
//
//    }
