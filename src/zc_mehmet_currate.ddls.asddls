@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_MEHMET_CURRATE'
@ObjectModel.semanticKey: [ 'CurID', 'CurDate' ]
//@UI.presentationVariant: [{ sortOrder: [{ by: 'CurDate', direction: #DESC }] }]
define root view entity ZC_MEHMET_CURRATE
  provider contract transactional_query
  as projection on ZR_MEHMET_CURRATE
{
  key CurID,

  key CurDate,
      //      CurRate,
      CurRateValue,
      LocalLastChangedAt

}
