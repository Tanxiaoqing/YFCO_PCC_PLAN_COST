interface ZIF_FCO_COSTING_TYPES
  public .


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
    BEGIN OF ys_plan_object,
      object_number  TYPE j_objnr,
      object         TYPE REF TO zif_fco_costing_order,
      plan_data      TYPE fins_plan_api_plandata_int_tt,
      standard_data  TYPE fins_plan_api_plandata_int_tt,
    END OF ys_plan_object .
  types:
    yt_plan_object TYPE SORTED TABLE OF ys_plan_object WITH UNIQUE KEY object_number .
endinterface.
