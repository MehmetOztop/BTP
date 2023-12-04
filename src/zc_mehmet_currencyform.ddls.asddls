//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Curreny Export Form Stream'
//define root view entity zc_mehmet_currencyform as select from data_source_name
//composition of target_data_source_name as _association_name
//{
//
//    _association_name // Make association public
//}

@EndUserText.label: 'Curreny Export Form Stream'
//@VDM : { viewType:  #CONSUMPTION,
//         lifecycle.contract.type: #NONE }
@ObjectModel: {
    query.implementedBy: 'ABAP:ZCL_MEHMET_CURRENCYFORM'
}
define root custom entity zc_mehmet_currencyform
{
  key cur_id                  : zmehmet_de_cur_id;
  key cur_date                : datum;
      cur_rate_value          : zmehmet_de_cur_rate;
      @Semantics.largeObject.mimeType: 'FileMIMEType'
      @Semantics.largeObject.fileName: 'FileMIMEType'
      @Semantics.largeObject.contentDispositionPreference: #INLINE
      @OData.property.valueControl: 'FileContentValueControl'
      FileContentBin          : abap.rawstring( 0 );
      FileContentValueControl : rap_cp_odata_value_control;
      @Semantics.mimeType     : true
      FileMIMEType            : zmehmet_de_w3conttype;
      FileName                : zmehmet_de_sdok_filnm;
}
