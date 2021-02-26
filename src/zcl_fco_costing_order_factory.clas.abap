class ZCL_FCO_COSTING_ORDER_FACTORY definition
  public
  final
  create public .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCL_FCO_COSTING_ORDER_FACTORY .
  methods CREATE_OBJECT
    importing
      !IS_AUFK type AUFKV
    returning
      value(RO_OBJECT) type ref to zif_fco_costing_order .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA so_instance TYPE REF TO zcl_fco_costing_order_factory .
ENDCLASS.



CLASS ZCL_FCO_COSTING_ORDER_FACTORY IMPLEMENTATION.


  METHOD create_object.
    DATA lv_object_type TYPE j_obart.

    CHECK is_aufk-eb_post = abap_true.
    lv_object_type = is_aufk-objnr(2).

    CASE lv_object_type.
      WHEN if_fins_acdoc_obart_c=>gc_order OR if_fins_acdoc_obart_c=>gc_order_item.

        CASE is_aufk-autyp.
*         Create object for Mfg Order
          WHEN if_fco_ebw_constants=>gc_prod_order OR if_fco_ebw_constants=>gc_proc_order.
            IF is_aufk-flg_mltps = abap_false.
              CREATE OBJECT ro_object TYPE zcl_fco_costing_mfg_order
                EXPORTING
                  is_order = is_aufk.
            ELSE.
              CREATE OBJECT ro_object TYPE zcl_fco_costing_mfg_coby_order
                EXPORTING
                  is_order = is_aufk.
            ENDIF.
*         Create object for Maintenace Order
          WHEN OTHERS . "if_fco_ebw_constants=>gc_proc_order.
              CREATE OBJECT ro_object TYPE zcl_fco_costing_PM_order
                EXPORTING
                  is_order = is_aufk.

        ENDCASE.

    ENDCASE.

  ENDMETHOD.


  METHOD get_instance.
    IF so_instance IS INITIAL.
      CREATE OBJECT so_instance.
    ENDIF.

    ro_instance = so_instance.

  ENDMETHOD.
ENDCLASS.
