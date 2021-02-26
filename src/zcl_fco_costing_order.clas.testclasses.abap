*"* use this source file for your ABAP unit test classes

CLASS lcl_fco_ebw_order DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Fco_Ebw_Order
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>CL_FCO_EBW_ORDER
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO cl_fco_ebw_order.  "class under test

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: get_business_area FOR TESTING.
    METHODS: get_company_code FOR TESTING.
    METHODS: get_controlling_area FOR TESTING.
    METHODS: get_current_actual_costs FOR TESTING.
    METHODS: get_functional_area FOR TESTING.
    METHODS: get_material_number FOR TESTING.
    METHODS: get_object_class FOR TESTING.
    METHODS: get_object_number FOR TESTING.
    METHODS: get_object_type FOR TESTING.
    METHODS: get_order_category FOR TESTING.
    METHODS: get_order_id FOR TESTING.
    METHODS: get_plant FOR TESTING.
    METHODS: get_plan_costs FOR TESTING.
    METHODS: get_profit_center FOR TESTING.
    METHODS: get_source_doc FOR TESTING.
    METHODS: get_total_actual_costs FOR TESTING.
    METHODS: get_wip_calculation_method FOR TESTING.
    METHODS: get_wip_doc FOR TESTING.
    METHODS: get_wip_reserves FOR TESTING.
    METHODS: is_closed FOR TESTING.
    METHODS: is_delivery_completed FOR TESTING.
    METHODS: is_event_based FOR TESTING.
    METHODS: is_open FOR TESTING.
    METHODS: set_source_doc FOR TESTING.
    METHODS: set_wip_calculation_method FOR TESTING.
    METHODS: set_wip_doc FOR TESTING.
ENDCLASS.       "lcl_Fco_Ebw_Order


CLASS lcl_fco_ebw_order IMPLEMENTATION.

  METHOD class_setup.



  ENDMETHOD.


  METHOD class_teardown.



  ENDMETHOD.


  METHOD setup.

    DATA is_order TYPE aufkv.

    CREATE OBJECT f_cut
      EXPORTING
        is_order = is_order.
  ENDMETHOD.


  METHOD teardown.



  ENDMETHOD.


  METHOD get_business_area.

    DATA rv_business_area TYPE gsber.

    rv_business_area = f_cut->if_fco_ebw_object~get_business_area(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_business_area
      exp   = rv_business_area          "<--- please adapt expected value
    " msg   = 'Testing value rv_Business_Area'
*     level =
    ).
  ENDMETHOD.


  METHOD get_company_code.

    DATA rv_company_code TYPE bukrs.

    rv_company_code = f_cut->if_fco_ebw_object~get_company_code(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_company_code
      exp   = rv_company_code          "<--- please adapt expected value
    " msg   = 'Testing value rv_Company_Code'
*     level =
    ).
  ENDMETHOD.


  METHOD get_controlling_area.

    DATA rv_controlling_area TYPE kokrs.

    rv_controlling_area = f_cut->if_fco_ebw_object~get_controlling_area(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_controlling_area
      exp   = rv_controlling_area          "<--- please adapt expected value
    " msg   = 'Testing value rv_Controlling_Area'
*     level =
    ).
  ENDMETHOD.


  METHOD get_current_actual_costs.

    DATA et_actual_costs TYPE if_fco_ebw_types=>yt_actual_costs.
    TRY .
        f_cut->if_fco_ebw_object~get_current_actual_costs(
*     IMPORTING
*       ET_ACTUAL_COSTS = et_Actual_Costs
        ).
      CATCH cx_fco_ebw_exception INTO DATA(lo_dummy).
    ENDTRY.
    cl_abap_unit_assert=>assert_equals(
      act   = et_actual_costs
      exp   = et_actual_costs          "<--- please adapt expected value
    " msg   = 'Testing value et_Actual_Costs'
*     level =
    ).
  ENDMETHOD.


  METHOD get_functional_area.

    DATA rv_functional_area TYPE fkber.

    rv_functional_area = f_cut->if_fco_ebw_object~get_functional_area(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_functional_area
      exp   = rv_functional_area          "<--- please adapt expected value
    " msg   = 'Testing value rv_Functional_Area'
*     level =
    ).
  ENDMETHOD.


  METHOD get_material_number.

    DATA rv_material_number TYPE matnr.

    rv_material_number = f_cut->if_fco_ebw_object~get_material_number(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_material_number
      exp   = rv_material_number          "<--- please adapt expected value
    " msg   = 'Testing value rv_Material_Number'
*     level =
    ).
  ENDMETHOD.


  METHOD get_object_class.

    DATA rv_object_class TYPE scope_cv.

    rv_object_class = f_cut->if_fco_ebw_object~get_object_class(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_object_class
      exp   = rv_object_class          "<--- please adapt expected value
    " msg   = 'Testing value rv_Object_Class'
*     level =
    ).
  ENDMETHOD.


  METHOD get_object_number.

    DATA rv_object_number TYPE j_objnr.

    rv_object_number = f_cut->if_fco_ebw_object~get_object_number(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_object_number
      exp   = rv_object_number          "<--- please adapt expected value
    " msg   = 'Testing value rv_Object_Number'
*     level =
    ).
  ENDMETHOD.


  METHOD get_object_type.

    DATA rv_object_type TYPE j_obart.

    rv_object_type = f_cut->if_fco_ebw_object~get_object_type(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_object_type
      exp   = rv_object_type          "<--- please adapt expected value
    " msg   = 'Testing value rv_Object_Type'
*     level =
    ).
  ENDMETHOD.


  METHOD get_order_category.

    DATA rv_order_category TYPE auftyp.

    rv_order_category = f_cut->if_fco_ebw_object~get_order_category(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_order_category
      exp   = rv_order_category          "<--- please adapt expected value
    " msg   = 'Testing value rv_Order_Category'
*     level =
    ).
  ENDMETHOD.


  METHOD get_order_id.

    DATA rv_order_id TYPE aufnr.

    rv_order_id = f_cut->if_fco_ebw_object~get_order_id(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_order_id
      exp   = rv_order_id          "<--- please adapt expected value
    " msg   = 'Testing value rv_Order_Id'
*     level =
    ).
  ENDMETHOD.


  METHOD get_plant.

    DATA rv_plant TYPE werks.

    rv_plant = f_cut->if_fco_ebw_object~get_plant(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_plant
      exp   = rv_plant          "<--- please adapt expected value
    " msg   = 'Testing value rv_Plant'
*     level =
    ).
  ENDMETHOD.


  METHOD get_plan_costs.

    DATA et_plan_costs TYPE if_fco_ebw_types=>yt_plan_costs.
    try.
    f_cut->if_fco_ebw_object~get_plan_costs(
*     IMPORTING
*       ET_PLAN_COSTS = et_Plan_Costs
    ).
      CATCH cx_fco_ebw_exception INTO DATA(lo_dummy).
    ENDTRY.
    cl_abap_unit_assert=>assert_equals(
      act   = et_plan_costs
      exp   = et_plan_costs          "<--- please adapt expected value
    " msg   = 'Testing value et_Plan_Costs'
*     level =
    ).
  ENDMETHOD.


  METHOD get_profit_center.

    DATA rv_profit_center TYPE prctr.

    rv_profit_center = f_cut->if_fco_ebw_object~get_profit_center(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_profit_center
      exp   = rv_profit_center          "<--- please adapt expected value
    " msg   = 'Testing value rv_Profit_Center'
*     level =
    ).
  ENDMETHOD.


  METHOD get_source_doc.

    DATA ro_source_doc TYPE REF TO if_fco_ebw_ac_document.

    ro_source_doc = f_cut->if_fco_ebw_object~get_source_doc(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = ro_source_doc
      exp   = ro_source_doc          "<--- please adapt expected value
    " msg   = 'Testing value ro_Source_Doc'
*     level =
    ).
  ENDMETHOD.


  METHOD get_total_actual_costs.

    DATA et_actual_costs TYPE if_fco_ebw_types=>yt_actual_costs.
    try.
    f_cut->if_fco_ebw_object~get_total_actual_costs(
*     IMPORTING
*       ET_ACTUAL_COSTS = et_Actual_Costs
    ).
      CATCH cx_fco_ebw_exception INTO DATA(lo_dummy).
    ENDTRY.
    cl_abap_unit_assert=>assert_equals(
      act   = et_actual_costs
      exp   = et_actual_costs          "<--- please adapt expected value
    " msg   = 'Testing value et_Actual_Costs'
*     level =
    ).
  ENDMETHOD.


  METHOD get_wip_calculation_method.

    DATA rv_method TYPE if_fco_ebw_types=>yd_wip_calculation_method.

    rv_method = f_cut->if_fco_ebw_object~get_wip_calculation_method(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rv_method
      exp   = rv_method          "<--- please adapt expected value
    " msg   = 'Testing value rv_Method'
*     level =
    ).
  ENDMETHOD.


  METHOD get_wip_doc.

    DATA ro_wip_doc TYPE REF TO if_fco_ebw_ac_document.

    ro_wip_doc = f_cut->if_fco_ebw_object~get_wip_doc(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = ro_wip_doc
      exp   = ro_wip_doc          "<--- please adapt expected value
    " msg   = 'Testing value ro_Wip_Doc'
*     level =
    ).
  ENDMETHOD.


  METHOD get_wip_reserves.

    DATA et_wip_reserves TYPE if_fco_ebw_types=>yt_wip_reserves.
    try.
    f_cut->if_fco_ebw_object~get_wip_reserves(
*     IMPORTING
*       ET_WIP_RESERVES = et_Wip_Reserves
    ).
      CATCH cx_fco_ebw_exception INTO DATA(lo_dummy).
    ENDTRY.
    cl_abap_unit_assert=>assert_equals(
      act   = et_wip_reserves
      exp   = et_wip_reserves          "<--- please adapt expected value
    " msg   = 'Testing value et_Wip_Reserves'
*     level =
    ).
  ENDMETHOD.


  METHOD is_closed.

    DATA rb_closed TYPE abap_bool.

    rb_closed = f_cut->if_fco_ebw_object~is_closed(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rb_closed
      exp   = rb_closed          "<--- please adapt expected value
    " msg   = 'Testing value rb_Closed'
*     level =
    ).
  ENDMETHOD.


  METHOD is_delivery_completed.

    DATA rb_delivery_completed TYPE abap_bool.

    rb_delivery_completed = f_cut->if_fco_ebw_object~is_delivery_completed(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rb_delivery_completed
      exp   = rb_delivery_completed          "<--- please adapt expected value
    " msg   = 'Testing value rb_Delivery_Completed'
*     level =
    ).
  ENDMETHOD.


  METHOD is_event_based.

    DATA rb_event_based TYPE abap_bool.

    rb_event_based = f_cut->if_fco_ebw_object~is_event_based(  ).

    cl_abap_unit_assert=>assert_equals(
      act   = rb_event_based
      exp   = rb_event_based          "<--- please adapt expected value
    " msg   = 'Testing value rb_Event_Based'
*     level =
    ).
  ENDMETHOD.


  METHOD is_open.

    DATA rb_open TYPE abap_bool.
    try.
    rb_open = f_cut->if_fco_ebw_object~is_open(  ).
      CATCH cx_fco_ebw_exception INTO DATA(lo_dummy).
    ENDTRY.
    cl_abap_unit_assert=>assert_equals(
      act   = rb_open
      exp   = rb_open          "<--- please adapt expected value
    " msg   = 'Testing value rb_Open'
*     level =
    ).
  ENDMETHOD.


  METHOD set_source_doc.

    DATA io_source_doc TYPE REF TO if_fco_ebw_ac_document.

    f_cut->if_fco_ebw_object~set_source_doc( io_source_doc ).

  ENDMETHOD.


  METHOD set_wip_calculation_method.

    DATA iv_method TYPE if_fco_ebw_types=>yd_wip_calculation_method.

    f_cut->if_fco_ebw_object~set_wip_calculation_method( iv_method ).

  ENDMETHOD.


  METHOD set_wip_doc.

    DATA io_wip_doc TYPE REF TO if_fco_ebw_ac_document.

    f_cut->if_fco_ebw_object~set_wip_doc( io_wip_doc ).

  ENDMETHOD.




ENDCLASS.
