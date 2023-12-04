CLASS lhc_currency_rates DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Currency_Rates
        RESULT result,
      UpdateRates FOR MODIFY
        IMPORTING keys   FOR ACTION Currency_Rates~UpdateRates
        RESULT    result
        ,
      displayPDF FOR MODIFY
        IMPORTING keys FOR ACTION Currency_Rates~displayPDF RESULT result.
*      UpdateRatesTwo FOR READ
*        IMPORTING keys FOR FUNCTION Currency_Rates~UpdateRatesTwo RESULT result.
    DATA:
      caller TYPE REF TO zcl_mehmet_call_currency,
      values TYPE zmehmet_curr_tt,
      val    TYPE TABLE FOR CREATE zr_mehmet_currate,
      del    TYPE TABLE FOR DELETE zr_mehmet_currate.
ENDCLASS.

CLASS lhc_currency_rates IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD UpdateRates.


*    READ ENTITIES OF zr_mehmet_currate IN LOCAL MODE
*    ENTITY Currency_Rates
*    ALL FIELDS WITH    cur_id is not initial
**    FIELDS ( curid )
**    WITH CORRESPONDING #(  )
*    RESULT DATA(curr).

    caller = NEW zcl_mehmet_call_Currency(  ).
    TRY.
        values = caller->read_rates(  ).
      CATCH cx_static_check.
        "handle exception
    ENDTRY.
*    LOOP AT values INTO DATA(val_s).
*      MODIFY ENTITIES OF zr_mehmet_currate IN LOCAL MODE
*                ENTITY Currency_Rates
*                CREATE from val (
*                 CurID = val_s-cur_id
*                  CreatedAt = val_s-created_at
*                  CreatedBy = val_s-created_by
*                  CurDate = val_s-cur_date
*                  CurRate = val_s-cur_rate
*                  LastChangedAt = val_s-last_changed_at
*                  LocalLastChangedAt = val_s-local_last_changed_at
*                  LocalLastChangedBy = val_s-local_last_changed_by
*                           )
**                %cid = val_s-cur_id && val_s-cur_date
*
*
*                   FAILED failed
*                   REPORTED reported.
*    ENDLOOP.

*    MODIFY ENTITIES OF zr_mehmet_currate IN LOCAL MODE
*              ENTITY Currency_Rates
*              CREATE FROM VALUE #( FOR line IN values
*              ( CurID = line-cur_id
*                CreatedAt = line-created_at
*                CreatedBy = line-created_by
*                CurDate = line-cur_date
*                CurRate = line-cur_rate
*                LastChangedAt = line-last_changed_at
*                LocalLastChangedAt = line-local_last_changed_at
*                LocalLastChangedBy = line-local_last_changed_by
*                %cid = line-cur_id && line-cur_date
*              )
*              )
*                 FAILED failed
*                 REPORTED reported.



*    LOOP AT values INTO DATA(line).
    val = VALUE #( FOR line IN values ( CurID = line-cur_id
                    CreatedAt = line-created_at
                    CreatedBy = line-created_by
                    CurDate = line-cur_date
                    CurRateValue = line-cur_rate_value
                    LastChangedAt = line-last_changed_at
                    LocalLastChangedAt = line-local_last_changed_at
                    LocalLastChangedBy = line-local_last_changed_by
                    %cid = line-cur_id && line-cur_date
                    %control = VALUE #(
                    CurID = if_abap_behv=>mk-on
                    CreatedAt = if_abap_behv=>mk-on
                    CreatedBy = if_abap_behv=>mk-on
                    CurDate = if_abap_behv=>mk-on
                    CurRateValue = if_abap_behv=>mk-on
                    )
                    )
                     ).
*      APPEND val[ 1 ] TO val.

*    ENDLOOP.
    del = VALUE #( FOR line IN values (
                    CurID = line-cur_id
                    CurDate = line-cur_date
*
*                    %cid = line-cur_id && line-cur_date
*                    %control = VALUE #(
*                    CurID = if_abap_behv=>mk-on
*                    CreatedAt = if_abap_behv=>mk-on
*                    CreatedBy = if_abap_behv=>mk-on
*                    CurDate = if_abap_behv=>mk-on
*                    CurRate = if_abap_behv=>mk-on
*                    )
                    )
                     ).

*val = values.

    MODIFY ENTITIES OF zr_mehmet_currate IN LOCAL MODE
              ENTITY Currency_Rates
              DELETE FROM del
                 FAILED failed
                 REPORTED reported.

    MODIFY ENTITIES OF zr_mehmet_currate IN LOCAL MODE
              ENTITY Currency_Rates
              CREATE FROM val
                 FAILED failed
                 REPORTED reported.

*    MODIFY ENTITIES operations of zr_mehmet_currate IN LOCAL MODE
*ENTITY Currency_Rates
*CREATE BY values
**FAILED failed
**REPORTED reported
*MAPPED values.
*    caller->post_rates(  ).
  ENDMETHOD.

*  METHOD UpdateRatesTwo.
*    caller = NEW zcl_mehmet_call_Currency(  ).
*    caller->read_rates(  ).
*    caller->post_rates(  ).
*  ENDMETHOD.

  METHOD displayPDF.


    DATA(res) = 2 + 2.
  ENDMETHOD.

ENDCLASS.
