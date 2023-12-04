CLASS zcl_mehmet_currencyform DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MEHMET_CURRENCYFORM IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
*    DATA lv_content TYPE rawstring.
    DATA lt_return TYPE STANDARD TABLE OF bapiret2.
    DATA lt_stream TYPE STANDARD TABLE OF zc_mehmet_currencyform.

    DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
    DATA(lv_top) = io_request->get_paging( )->get_page_size( ).


  ENDMETHOD.
ENDCLASS.
