class ZCL_FCO_COSTING_MFG_ORD_HELPER definition
  public
  create public .

public section.

  interfaces zif_fco_costing_helper .

  methods CONSTRUCTOR
    importing
      !IO_OBJECT type ref to zif_fco_costing_order .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZCL_FCO_COSTING_MFG_ORD_HELPER IMPLEMENTATION.


  method CONSTRUCTOR.
     zif_fco_costing_helper~MO_OBJECT = io_object.
  endmethod.


  method zif_fco_costing_helper~CALCULATE_PREPLAN_COST.
  endmethod.


  METHOD zif_fco_costing_helper~derive_acdocp_item.

*    DATA lv_object_type     TYPE j_obart.
*    DATA ls_wbs_obj         TYPE prps.
*    DATA ms_controlling_area TYPE TKA01.
*    DATA ms_costing_order TYPE CAUFVD.
*
**   TODO
**    get_controlling_area_data(
**       EXPORTING
**          iv_kokrs = is_costing_order-kokrs
**       IMPORTING
**          es_tka01 = ms_controlling_area ).
*
**   Fill general fields
*    cs_plan_cost-rldnr      = cl_fins_acdoc_util=>get_leading_ledger( ).
*    cs_plan_cost-kokrs      = ms_controlling_area-kokrs.
*    cs_plan_cost-periv      = ms_controlling_area-lmona.
*    cs_plan_cost-ktopl      = ms_controlling_area-ktopl.
*    cs_plan_cost-rkcur      = ms_controlling_area-waers.
*
**   Fill costing order level fields
*    cs_plan_cost-aufnr      = ms_costing_order-aufnr.
*    cs_plan_cost-rbukrs     = ms_costing_order-bukrs.
*    cs_plan_cost-werks      = ms_costing_order-werks.
*    cs_plan_cost-rfarea     = ms_costing_order-func_area.
*    cs_plan_cost-rbusa      = ms_costing_order-gsber.
*    cs_plan_cost-rco_ocur   = ms_costing_order-waers.
*    cs_plan_cost-rhcur      = ms_costing_order-waers.  "for PP order, CO object currency equals to company code currency
*
**   Use the profit center from the order first
*    cs_plan_cost-prctr = ms_costing_order-prctr.
*    IF cs_plan_cost-prctr IS INITIAL.
**     Use the dummpy profit center if no profit center found in order master data
**      TODO
*      "      cs_plan_cost-prctr = ms_controlling_area-dprct.
*    ENDIF.
*
**   Account assignment type
*    CALL FUNCTION 'OBJECT_NUMBER_TYPE_GET'
*      EXPORTING
*        objnr     = iv_object_number
*      IMPORTING
*        obart_org = lv_object_type.
*    cs_plan_cost-accasty   = lv_object_type.
*
**   Order item number
*    get_order_item_number(
*      EXPORTING
*        iv_object_number  = iv_object_number
*        iv_order          = ms_costing_order-aufnr
*      IMPORTING
*        ev_order_item_number = cs_plan_cost-aufps ).
*
*    cs_plan_cost-poper      = is_costing_item-period.
*    cs_plan_cost-ryear      = is_costing_item-gjahr.
*    cs_plan_cost-racct      = is_costing_item-kstar.
*    cs_plan_cost-matnr      = is_costing_item-matnr.
*    cs_plan_cost-pernr      = is_costing_item-pernr.
*    cs_plan_cost-rcntr      = is_costing_item-kostl.
*    cs_plan_cost-lstar      = is_costing_item-lstar.
*
**   Get WBS Element external ID
*    CALL FUNCTION 'CJPN_GET_WBS_ELEMENT'
*      EXPORTING
*        i_pspnr     = is_costing_item-pspnr
*      IMPORTING
*        e_prps      = ls_wbs_obj
*      EXCEPTIONS
*        input_error = 1
*        not_found   = 2
*        OTHERS      = 3.
*
*    cs_plan_cost-ps_posid   = ls_wbs_obj-posid.
*
**   Business transaction type
*    cs_plan_cost-bttype     = is_costing_item-vrgng.
*
**   Partner account assignments
*    get_par_account_assignment(
*      EXPORTING
*        iv_partner_object               = is_costing_item-parob
*        iv_order                        = ms_costing_order-aufnr
*      IMPORTING
*        ev_partner_account_assign_type  = cs_plan_cost-paccasty
*        ev_partner_cost_center          = cs_plan_cost-scntr
*        ev_partner_activity_type        = cs_plan_cost-plstar
*        ev_partner_order                = cs_plan_cost-paufnr ).
*
**   Operation and Workcenter
*    cs_plan_cost-vornr = is_costing_item-vornr.
*    cs_plan_cost-arbid = is_costing_item-arbid.
*
**   Debit/credit indicator
*    get_debit_credit_indicator(
*      EXPORTING
*        iv_item_category          = is_costing_item-typps
*        iv_item_qty               = is_costing_item-menge
*        iv_item_amount            = is_costing_item-wertn
*      IMPORTING
*        ev_credit_debit_indicator = cs_plan_cost-co_belkz ).
  ENDMETHOD.
ENDCLASS.
