class ZCL_FCO_COSTING_MGR definition
  public
  final
  create private .

public section.
  type-pools ABAP .
  type-pools KKCK .

  types:
    BEGIN OF ys_plan_data,
        object_number  TYPE objnr,
        plan_data      TYPE fins_plan_api_plandata_int_tt,
        preplan_data      TYPE fins_plan_api_plandata_int_tt,
    END OF ys_plan_data .
  types:
    yt_plan_data TYPE STANDARD TABLE OF ys_plan_data WITH KEY object_number .
  types:
    BEGIN OF ys_costing_item.
        INCLUDE TYPE ckkalktab.
    TYPES:
      vrgng  TYPE cossa-vrgng,
      meinh  TYPE co_meinh,
      gjahr  TYPE cobk-gjahr,
      period TYPE cobk-perab,
      amount TYPE coeja-meg001,
      wkg    TYPE coeja-wkg001,
      wkf    TYPE coeja-wkf001,
      wog    TYPE coeja-wog001,
      wtg    TYPE coeja-wtg001,
      END   OF ys_costing_item .
  types:
    yt_costing_item TYPE STANDARD TABLE OF ys_costing_item WITH EMPTY KEY .
  types:
    BEGIN OF ys_costing_object_item,
        object_number  TYPE objnr,
        costing_object TYPE ckcoueb,
        costing_items  TYPE yt_costing_item,
      END OF ys_costing_object_item .
  types:
    yt_costing_object_item TYPE STANDARD TABLE OF ys_costing_object_item WITH KEY object_number .
  types:
    BEGIN OF co_product,
        matnr   TYPE ckimatix-matnr,
        werks   TYPE ckimatix-werks,
        objnr   TYPE keko-objnr,
        posnr   TYPE ckimatix-posnr,    "Auftragspositionsnummer
        kalktab TYPE ckf_standard_kalktab_table,
      END OF co_product .

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCL_FCO_COSTING_MGR .
  methods INITIALIZE
    importing
      !IS_COSTING_ORDER type CAUFVD
      !IS_COSTING_HEADER type CKIBEW
      !IS_COSTING_OBJECT type CKCOUEB .
  methods COLLECT_COSTING_ITEM
    importing
      !IS_COSTING_OBJECT type CKCOUEB
      !IS_COSTING_ITEM type YS_COSTING_ITEM .
  methods COLLECT_OVERHEAD_ITEM
    importing
      !IS_COSTING_OBJECT type CKCOUEB
      !IT_KALKTAB type CKF_STANDARD_KALKTAB_TABLE .
protected section.
private section.

  class-data GO_INSTANCE type ref to ZCL_FCO_COSTING_MGR .
  data MS_COSTING_ORDER type CAUFVD .
  data MS_COSTING_HEADER type CKIBEW .
  data MS_COSTING_OBJECT type CKCOUEB .
  data MS_CONTROLLING_AREA type TKA01 .
  data MT_COSTING_OBJECT_ITEM type YT_COSTING_OBJECT_ITEM .
  data MT_PLAN_COST type YT_PLAN_DATA .
  data MT_ORDER_ITEM type MPET_ORDER_ITEM .
  class-data MO_PLAN_COST_API_WRITE type ref to IF_FINS_PLANNING_API_WRITE .
  data MV_PLAN_CATEGORY type FCOM_CATEGORY .
  data MV_PREPLAN_CATEGORY type FCOM_CATEGORY .
  data LT_COSTING_OBJECT_ITEM type YT_COSTING_OBJECT_ITEM .
  data MB_IS_COST_ITEM_GEN_PHASE type BOOLE_D value ' ' ##NO_TEXT.
  data MV_LEADING_LEDGER type FINS_LEDGER .

  methods CHECK_ORDER_VALIDITY
    returning
      value(RV_ORDER_VALID) type ABAP_BOOL .
  methods GENERATE_PLAN_COSTS
    raising
      CX_FCO_PCC_EXCEPTION .
  methods GENERATE_STANDARD_COSTS .
  methods SAVE_COSTS_TO_ACDOCP .
ENDCLASS.



CLASS ZCL_FCO_COSTING_MGR IMPLEMENTATION.


  METHOD CHECK_ORDER_VALIDITY.
    CLEAR rv_order_valid.

    CHECK ms_costing_order IS NOT INITIAL.
    CHECK ( ms_costing_order-autyp = '10' OR ms_costing_order-autyp = '40' ).

    rv_order_valid = abap_true.
  ENDMETHOD.


  METHOD collect_costing_item.
    DATA ls_aufkv TYPE aufkv.
    DATA ls_costing_object_item    TYPE ys_costing_object_item.

    CHECK check_order_validity( ) = abap_true.

*   Remove all zero item
    IF is_costing_item-wkg IS INITIAL AND
       is_costing_item-wkf IS INITIAL AND
       is_costing_item-amount IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lo_object_mgr) = zcl_fco_costing_order_mgr=>get_instance( ).
    DATA(lo_object) = lo_object_mgr->get_object( is_costing_object-objnr ).

    IF lo_object IS INITIAL.
      CALL FUNCTION 'K_ORDER_READ'
        EXPORTING
          aufnr     = is_costing_object-objnr+2(12)
        IMPORTING
          i_aufkv   = ls_aufkv
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc <> 0.
      ENDIF.
      lo_object = zcl_fco_costing_order_factory=>get_instance( )->create_object( ls_aufkv ).
      lo_object_mgr->add_object( lo_object ).
    ENDIF.

    lo_object->add_costing_items( is_costing_item ).







** Put to local buffer
*    READ TABLE mt_costing_object_item ASSIGNING <ls_costing_object_item>
*        WITH TABLE KEY object_number = is_costing_object-objnr.
*    IF sy-subrc <> 0.
*      APPEND INITIAL LINE TO mt_costing_object_item ASSIGNING <ls_costing_object_item>.
*      <ls_costing_object_item>-object_number  = is_costing_object-objnr.
*      <ls_costing_object_item>-costing_object = is_costing_object.
*    ENDIF.
*    APPEND is_costing_item TO <ls_costing_object_item>-costing_items.


  ENDMETHOD.


  METHOD collect_overhead_item.
    DATA ls_costing_item TYPE ys_costing_item.

    CHECK check_order_validity( ) = abap_true.
    "    CHECK check_plan_category_validity( ) = abap_true.

    LOOP AT it_kalktab INTO DATA(ls_kalktab) WHERE typps = 'G'.

      MOVE-CORRESPONDING ls_kalktab TO ls_costing_item.

      CALL FUNCTION 'K_DATE_TO_PERIOD_CONVERT'
        EXPORTING
          i_date             = ls_kalktab-steas
          i_kokrs            = ls_kalktab-kokrs_hrk
        IMPORTING
          e_gjahr            = ls_costing_item-gjahr
          e_perio            = ls_costing_item-period
        EXCEPTIONS
          no_period_determin = 1
          t009b_notfound     = 2
          t009_notfound      = 3
          OTHERS             = 4.
      IF sy-subrc <> 0.
        " Do nothing
      ENDIF.

      ls_costing_item-vrgng  = if_fins_bttype_c=>gc_kppz.
      ls_costing_item-amount = ls_kalktab-menge.
      ls_costing_item-wkg = ls_kalktab-wertn.
      ls_costing_item-wkf = ls_kalktab-wrtfx.
      ls_costing_item-wog = ls_kalktab-wrtfw_kpf.
      ls_costing_item-wtg = ls_kalktab-wrtfw_pos.

      collect_costing_item(
        EXPORTING
          is_costing_object = is_costing_object
          is_costing_item   = ls_costing_item ).
    ENDLOOP.
  ENDMETHOD.


  METHOD generate_plan_costs.
    DATA ls_plan_cost           TYPE fins_plan_api_plandata_int.



    DATA(lt_objects) = zcl_fco_costing_order_mgr=>get_instance( )->get_objects( ).

    CHECK lt_objects IS NOT INITIAL.

    LOOP AT lt_objects ASSIGNING FIELD-SYMBOL(<fs_object>).

      DATA(lt_costing_item) = <fs_object>-object->get_costing_items( ).
      DATA(mo_helper) = <fs_object>-object->get_helper_class( ).

      IF <fs_object>-object_number CS if_fins_acdoc_obart_c=>gc_order. "OR
       " mo_helper->calculate_overhead( ).
      ENDIF.

      LOOP AT lt_costing_item ASSIGNING FIELD-SYMBOL(<fs_costing_item>).
        CLEAR ls_plan_cost.

        mo_helper->derive_acdocp_item(
         EXPORTING
            iv_object_number = <fs_object>-object_number
            is_costing_item = <fs_costing_item>
          CHANGING
            cs_plan_cost  = ls_plan_cost ) .

        APPEND ls_plan_cost to <fs_object>-plan_data.
      ENDLOOP.

    ENDLOOP.


*    DATA ls_plan_cost           TYPE fins_plan_api_plandata_int.
*    DATA lt_plan_cost           TYPE fins_plan_api_plandata_int_tt.
*
*
**   Recalculate overhead on order header and apportion the overhead costs from order header to order items
*    LOOP AT mt_costing_object_item INTO DATA(ls_costing_object_item)
*      WHERE object_number CS 'OR'.
*      calculate_plan_cost_overhead(
*        EXPORTING
*          is_costing_object_item  = ls_costing_object_item
*         IMPORTING
*          et_overhead             = DATA(lt_overhead) ).
*      EXIT.
*    ENDLOOP.
*
*
**   FIll costing object level fields
*    LOOP AT mt_costing_object_item INTO ls_costing_object_item.
*
**     Delete obsolete overhead
*      DELETE ls_costing_object_item-costing_items WHERE typps = 'G'.
**     Read newly calculated and apportioned overhead
*      READ TABLE lt_overhead ASSIGNING FIELD-SYMBOL(<ls_overhead>)
*        WITH KEY object_number = ls_costing_object_item-object_number.
*      IF sy-subrc = 0.
*        APPEND LINES OF <ls_overhead>-costing_items TO ls_costing_object_item-costing_items.
*      ENDIF.
*
**     Fill costing item level fields
*      LOOP AT ls_costing_object_item-costing_items ASSIGNING FIELD-SYMBOL(<ls_costing_item>).
*        CLEAR ls_plan_cost.
*        ls_plan_cost-category   = mv_plan_category.
*        derive_acdocp_item(
*          EXPORTING
*            iv_object_number = ls_costing_object_item-costing_object-objnr
*            is_costing_item = <ls_costing_item>
*          CHANGING
*            cs_plan_cost  = ls_plan_cost ).
**   posting date
*        IF NOT <ls_costing_item>-steas IS INITIAL.
*          ls_plan_cost-budat    = <ls_costing_item>-steas.
*        ELSE.
*          ls_plan_cost-budat    = ls_costing_object_item-costing_object-datum.
*        ENDIF.
*
*        IF ls_plan_cost-co_belkz = 'L'.
*          ls_plan_cost-budat    = <ls_costing_item>-ssedd.
*        ENDIF.
*
**   Derive work center
*        IF ls_plan_cost-arbid IS INITIAL.
*          mo_helper->get_work_center_from_order(
*            EXPORTING
*              iv_order_number     = ms_costing_order-aufnr
*              iv_operation_number = ls_plan_cost-vornr
*            IMPORTING
*              ev_work_center      = ls_plan_cost-arbid ).
*        ENDIF.
*
**       Quantity and unit of measure
*        ls_plan_cost-rvunit     = <ls_costing_item>-meinh.
*        ls_plan_cost-vmsl       = <ls_costing_item>-menge.
*
**       Transaction currency
*        ls_plan_cost-rwcur      = <ls_costing_item>-fwaer.
**       Amounts and quantities fields
*        ls_plan_cost-ksl        = <ls_costing_item>-wertn.
*        ls_plan_cost-kfsl       = <ls_costing_item>-wrtfx.
*        ls_plan_cost-co_osl     = <ls_costing_item>-wrtfw_kpf.
*        "for PP order, assign CO object currency also to company code currency
*        ls_plan_cost-hsl        = <ls_costing_item>-wrtfw_kpf.
*        ls_plan_cost-wsl        = <ls_costing_item>-wrtfw_pos.
**        Lot size independent flag
*        IF <ls_costing_item>-psknz = 'F'. "lot size independent
*          ls_plan_cost-psknz = 'X'.
*        ELSE.
*          ls_plan_cost-psknz = ''. "lot size dependent
*        ENDIF.
*
**       Collect the plan cost
*        APPEND ls_plan_cost TO lt_plan_cost.
*      ENDLOOP.
*    ENDLOOP.
*
*    rebuild_joint_prod_pln_cst_hdr(
*    CHANGING
*      ct_plan_cost = lt_plan_cost ).
*
**Build table with temp object number and plan costs table mapping, for use of switching to real order number.
*    READ TABLE mt_plan_cost ASSIGNING FIELD-SYMBOL(<ls_plan_cost>) WITH KEY object_number = ms_costing_object-objnr.
*    IF sy-subrc <> 0.
*      APPEND INITIAL LINE TO mt_plan_cost ASSIGNING <ls_plan_cost>.
*      <ls_plan_cost>-object_number  = ms_costing_object-objnr.
*      <ls_plan_cost>-plan_data = lt_plan_cost.
*    ELSE.
*      <ls_plan_cost>-plan_data = lt_plan_cost.
*    ENDIF.

  ENDMETHOD.


  method GENERATE_STANDARD_COSTS.
  endmethod.


  METHOD GET_INSTANCE.
    IF go_instance IS INITIAL.
      CREATE OBJECT go_instance.
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.


  METHOD INITIALIZE.
    DATA lt_aggrlevel                 TYPE if_fins_planning_api_write=>yt_field.
    DATA lt_message                   TYPE if_fins_planning_api_write=>yt_msg.

    FIELD-SYMBOLS <lt_message>        TYPE bapiret2.

    ms_costing_order = is_costing_order.
    ms_costing_header = is_costing_header.
    ms_costing_object = is_costing_object.

    CHECK check_order_validity( ) = abap_true.

** Get leading ledger
*    mv_leading_ledger = cl_fins_acdoc_util=>get_leading_ledger( ).
*
*    TRY .
**       Get plan category for plan costs and preplan costs
*        mv_plan_category    = mo_helper->get_plan_category( if_fco_pcc_helper=>gc_plan_category-plan_cost ).
*        mv_preplan_category = mo_helper->get_plan_category( if_fco_pcc_helper=>gc_plan_category-preplan_cost ).
*
**        mo_helper->get_controlling_area_data(
**          EXPORTING
**            iv_kokrs = is_costing_order-kokrs
**          IMPORTING
**            es_tka01 = ms_controlling_area ).
*
*        mo_helper->get_order_item(
*          EXPORTING
*            iv_order_number = ms_costing_order-aufnr
*          IMPORTING
*            et_order_item   = mt_order_item ).
*      CATCH cx_fco_pcc_exception INTO DATA(lo_exception).
*        collect_message( lo_exception->get_message( ) ).
*        RETURN.
*    ENDTRY.
*
*    reset_costing( ).
*
**   ACDOCP API instance
*    IF mo_plan_cost_api_write IS INITIAL.
**     Aggregation level required by ACDOCP API
*      lt_aggrlevel = VALUE #(
**       Time dimensions
*        ( CONV #( 'RYEAR' ) )
*        ( CONV #( 'POPER' ) )
*        ( CONV #( 'PERIV' ) )
*        ( CONV #( 'BUDAT' ) )
**       Category, ledger and account data
*        ( CONV #( 'CATEGORY' ) )
*        ( CONV #( 'RLDNR' ) )
*        ( CONV #( 'RACCT' ) )
*        ( CONV #( 'KTOPL' ) )
*        ( CONV #( 'CO_BELKZ' ) )
**       Controlling area and company code
*        ( CONV #( 'KOKRS' ) )
*        ( CONV #( 'RBUKRS' ) )
**       Cost center and dependent fields
*        ( CONV #( 'RCNTR' ) )
*        ( CONV #( 'PRCTR' ) )
*        ( CONV #( 'RFAREA' ) )
*        ( CONV #( 'LSTAR' ) )
*        ( CONV #( 'SEGMENT' ) )
*        ( CONV #( 'RBUSA' ) )
**  corresponding partner fields
**    ( CONV #( 'PLSTAR' ) )
**    ( CONV #( 'PBUKRS' ) )
**    ( CONV #( 'SCNTR' ) )
**    ( CONV #( 'PPRCTR' ) )
**    ( CONV #( 'PSEGMENT' ) )
*        ( CONV #( 'PAUFNR' ) )
*        ( CONV #( 'PLSTAR' ) )
*        ( CONV #( 'SCNTR' ) )
**       Material, plant and order
*        ( CONV #( 'MATNR' ) )
*        ( CONV #( 'WERKS' ) )
*        ( CONV #( 'AUFNR' ) )
**       Account assignment type
*        ( CONV #( 'ACCASTY' ) )
*        ( CONV #( 'PACCASTY') )
**       Company code and group currency
*        ( CONV #( 'RHCUR' ) )
*        ( CONV #( 'HSL' ) )
*        ( CONV #( 'RKCUR' ) )
*        ( CONV #( 'KSL' ) )
*        ( CONV #( 'KFSL' ) )
**       Other currencies and amounts are not in aggregation since they shall be derived
**       Quantity and unit of measure
*        ( CONV #( 'RVUNIT' ) )
*        ( CONV #( 'VMSL' ) )
**       Operation and work center
*        ( CONV #( 'VORNR' ) )
*        ( CONV #( 'ARBID' ) )
**       WBS Element and Pesonnel Number and Business Transaction Type
*        ( CONV #( 'PS_POSID' ) )
*        ( CONV #( 'PERNR' ) )
*        ( CONV #( 'BTTYPE' ) )
*        ( CONV #( 'AUFPS' ) )
**        lot-size dependent indicator
*        ( CONV #( 'PSKNZ' ) )
*
*      ).
*
*      cl_fins_planning_api_factory=>get_instance( )->create_fins_planning_write(
*        EXPORTING
*          it_aggrlevel    = lt_aggrlevel
*        IMPORTING
*          eo_api_write    = mo_plan_cost_api_write
*          et_message      = lt_message ).
*      LOOP AT lt_message ASSIGNING <lt_message> WHERE type = 'E' OR type = 'A' OR type = 'X'.
*        ASSERT 0 = 1.
*      ENDLOOP.
*    ENDIF.

  ENDMETHOD.


  method SAVE_COSTS_TO_ACDOCP.
  endmethod.
ENDCLASS.
