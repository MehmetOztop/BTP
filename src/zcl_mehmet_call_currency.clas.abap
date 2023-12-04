CLASS zcl_mehmet_call_currency DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES:
      if_oo_adt_classrun.

    TYPES:
      BEGIN OF post_s,
        user_id TYPE i,
        id      TYPE i,
        title   TYPE string,
        body    TYPE string,
      END OF post_s,

      post_tt TYPE TABLE OF post_s WITH EMPTY KEY,



      BEGIN OF currency_s,
        _CrossOrder     TYPE string,
        _CurrencyCode   TYPE string,
        _Kod            TYPE string,
        Unit            TYPE string,
        Isim            TYPE string,
        CurrencyName    TYPE string,
        ForexBuying     TYPE string,
        ForexSelling    TYPE string,
        BanknoteBuying  TYPE string,
        BanknoteSelling TYPE string,
        CrossRateUSD    TYPE string,
        CrossRateOther  TYPE string,
      END OF currency_s,

      currency_tt TYPE TABLE OF currency_s WITH EMPTY KEY,

      BEGIN OF tarih_s,
        _bulten_no TYPE string,
        _Date      TYPE string,
        _Tarih     TYPE string,
        Currency   TYPE currency_tt,
      END OF tarih_s,

      BEGIN OF cur_s,
        Tarih_Date TYPE tarih_s,
*        Currency   TYPE currency_tt,
      END OF cur_s,

      cur_tt TYPE TABLE OF cur_s WITH EMPTY KEY,

      BEGIN OF post_without_id_s,
        user_id TYPE i,
        title   TYPE string,
        body    TYPE string,
      END OF post_without_id_s.

    METHODS:
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check,

      read_rates
        RETURNING VALUE(result) TYPE  zmehmet_curr_tt
        RAISING   cx_static_check,

        generate_pdf
        importing values type string,
*
*      read_single_post
*        IMPORTING id            TYPE i
*        RETURNING VALUE(result) TYPE post_s
*        RAISING   cx_static_check,
*
*      create_post
*        IMPORTING post_without_id TYPE post_without_id_s
*        RETURNING VALUE(result)   TYPE string
*        RAISING   cx_static_check,
*
*      update_post
*        IMPORTING post          TYPE post_s
*        RETURNING VALUE(result) TYPE string
*        RAISING   cx_static_check,

      post_rates

*      delete_post
*        IMPORTING id TYPE i
*        RAISING   cx_static_check
      .



  PRIVATE SECTION.
    CONSTANTS:
      base_url      TYPE string VALUE 'https://85a54324trial-trial.integrationsuitetrial-apim.us10.hana.ondemand.com:443/85a54324trial/',
      content_type  TYPE string VALUE 'Content-type',
      client_id     TYPE string VALUE 'sb-7237df52-656e-4664-8cec-35cbddc67ba3!b193822|it-rt-85a54324trial!b26655',
      client_secret TYPE string VALUE '98d8a09f-8630-4da5-834f-a6cd1c716bbe$8ga6Y13Pw3MwYsdGBsGI2SUGrxCnrfVWFPsaC8zddgk=',
      json_content  TYPE string VALUE 'application/x-www-form-urlencoded'.
    DATA: rate_s TYPE zmehmet_currate,
          rate_t TYPE TABLE OF zmehmet_currate.
*       fm_name         TYPE ZMEHMET_DE_FUNCNAME,
*      fp_docparams    TYPE sfpdocparams,
*      fp_outputparams TYPE sfpoutputparams.
ENDCLASS.



CLASS ZCL_MEHMET_CALL_CURRENCY IMPLEMENTATION.


  METHOD post_rates.

*    DELETE FROM zmehmet_currate WHERE cur_date EQ @sy-datum.
*    MODIFY zmehmet_currate FROM TABLE @rate_t.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDMETHOD.


  METHOD create_client.
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.


  METHOD generate_pdf.
*CALL FUNCTION 'FP_JOB_OPEN'
* CHANGING
*        ie_outputparams = fp_outputparams
*      EXCEPTIONS
*        cancel          = 1
*        usage_error     = 2
*        system_error    = 3
*        internal_error  = 4
*        OTHERS          = 5.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.


*      CALL FUNCTION 'PTRM_WEB_TRIP_GET_SAVE_TO_SHB'
**        EXPORTING
**          i_employeenumber = lv_pernr
**          i_tripnumber     = lv_trip_no
**          i_trip_action    = lv_mode
**          i_periodnumber   = lv_periodnumber
**          i_trip_component = lv_trip_component
**        TABLES
**          et_return        = lt_return.
*.
* .
*
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    TRY.
        " Read
        DATA(all_rates) = read_rates(  ).

        out->write( all_rates ).

        me->post_rates(  ).
      CATCH cx_root INTO DATA(exc).
        out->write( exc->get_text(  ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD read_rates.
    DATA tstamp TYPE timestamp.
    " Get JSON of all rates
    FIELD-SYMBOLS: <header> TYPE any,
                   <field>  TYPE any.
    DATA values TYPE cur_s.
    DATA(url) = |{ base_url }|.
    DATA(client) = create_client( url ).
    DATA(req) = client->get_http_request(  ).
    req->set_authorization_basic( i_username = client_id i_password = client_secret ).
    DATA(response) = client->execute( if_web_http_client=>get )->get_text(  ).
*    DATA(res_x) = client->execute( if_web_http_client=>get )->to_xstring(  ).
*    DATA(res_json) = client->execute( if_web_http_client=>get ).
*    DATA(res_json) = client->get_http_request(  )->get_binary(  ).
    client->close(  ).
    FIELD-SYMBOLS <table> TYPE ANY TABLE.
*    DATA table TYPE string.
*    DATA currency TYPE cur_s.
*    assign <table>.
*    ASSIGN table TO <table>.
    " Convert JSON to post table
*    /ui2/cl_json=>deserialize( EXPORTING json = response
*                               CHANGING  data = result ).
    DATA(res) = /ui2/cl_json=>generate( EXPORTING json = response
                             ).
    ASSIGN res TO <header>.
    ASSIGN COMPONENT 'dereferenced' OF STRUCTURE <header> TO <field>.
*    xco_cp_json=>data->from_string( response )->apply(
*      VALUE #( ( xco_cp_json=>transformation->pascal_case_to_underscore ) )
*      )->write_to( REF #( result ) ).
    GET TIME STAMP FIELD tstamp."test
    xco_cp_json=>data->from_string( response )->write_to( REF #( values ) ).
    LOOP AT values-tarih_date-currency INTO DATA(res_s).
      APPEND VALUE #( cur_id = res_s-currencyname cur_date = sy-datum
*      cur_rate = res_s-forexbuying
                       cur_rate_value = res_s-forexbuying
                      created_by = sy-uname created_at = tstamp local_last_changed_by = sy-uname
                      local_last_changed_at = tstamp last_changed_at = tstamp ) TO rate_t.
    ENDLOOP.
    result = rate_t.
*    LOOP AT result-tarih_date-currency INTO DATA(res_ss).
*      APPEND VALUE #( cur_id = res_s-currencyname cur_date = sy-datum cur_rate = res_s-forexbuying ) TO rate_t.
*    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
