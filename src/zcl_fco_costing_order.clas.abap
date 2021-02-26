class ZCL_FCO_COSTING_ORDER definition
  public
  create public .

public section.

  interfaces zif_fco_costing_order .

  methods CONSTRUCTOR
    importing
      !IS_ORDER type AUFKV .
  PROTECTED SECTION.
private section.

  data MS_ORDER type AUFKV .
  data MS_ORDER_ITEM type AFPO .
ENDCLASS.



CLASS ZCL_FCO_COSTING_ORDER IMPLEMENTATION.


  METHOD constructor.

    ms_order = is_order.

    CALL FUNCTION 'K_AFPO_READ'
      EXPORTING
        i_aufnr   = ms_order-aufnr
      IMPORTING
        e_afpo    = ms_order_item
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc <> 0.
      "shall not happen
    ENDIF.

*   Instantiatiate help class for rcalling reusable business logic
    zif_fco_costing_order~set_helper_class( me ) .


  ENDMETHOD.


  METHOD zif_fco_costing_order~add_costing_items.
    APPEND is_costing_items TO zif_fco_costing_order~mt_costing_items.
  ENDMETHOD.


  METHOD zif_fco_costing_order~get_costing_items.
    rt_costing_items = zif_fco_costing_order~MT_COSTING_ITEMs.
  ENDMETHOD.


  METHOD zif_fco_costing_order~get_helper_class.
    ro_object = zif_fco_costing_order~mo_helper .
  ENDMETHOD.


  METHOD zif_fco_costing_order~set_helper_class.
    IF zif_fco_costing_order~mo_helper IS INITIAL.
      CREATE OBJECT zif_fco_costing_order~mo_helper TYPE zcl_fco_costing_MFG_ord_helpER
        EXPORTING
          io_object = io_object.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
