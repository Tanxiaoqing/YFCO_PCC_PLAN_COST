interface ZIF_FCO_COSTING_ORDER
  public .


  types:
*  types:
*    BEGIN OF ys_costing_item.
*      INCLUDE TYPE ckkalktab.
*  TYPES:
*      vrgng  TYPE cossa-vrgng,
*      meinh  TYPE co_meinh,
*      gjahr  TYPE cobk-gjahr,
*      period TYPE cobk-perab,
*      amount TYPE coeja-meg001,
*      wkg    TYPE coeja-wkg001,
*      wkf    TYPE coeja-wkf001,
*      wog    TYPE coeja-wog001,
*      wtg    TYPE coeja-wtg001,
*    END   OF ys_costing_item .
    yt_costing_item TYPE STANDARD TABLE OF zif_fco_costing_types=>ys_costing_item WITH EMPTY KEY .
  types:
    BEGIN OF ys_costing_object_item,
      object_number  TYPE objnr,
      costing_object TYPE ckcoueb,
      costing_items  TYPE yt_costing_item,
    END OF ys_costing_object_item .
  types:
    yt_costing_object_item TYPE STANDARD TABLE OF ys_costing_object_item WITH KEY object_number .

  data MT_COSTING_ITEMS type YT_COSTING_ITEM .
  data MO_HELPER type ref to zif_fco_costing_helper .

  methods GET_OBJECT_NUMBER
    returning
      value(RV_OBJECT_NUMBER) type J_OBJNR .
  methods GET_OBJECT_TYPE
    returning
      value(RV_OBJECT_TYPE) type J_OBART .
  methods GET_ORDER_CATEGORY
    returning
      value(RV_ORDER_CATEGORY) type AUFTYP .
  methods GET_ORDER_ID
    returning
      value(RV_ORDER_ID) type AUFNR .
  methods GET_COMPANY_CODE
    returning
      value(RV_COMPANY_CODE) type BUKRS .
  methods GET_CONTROLLING_AREA
    returning
      value(RV_CONTROLLING_AREA) type KOKRS .
  methods GET_PLANT
    returning
      value(RV_PLANT) type WERKS .
  methods GET_PROFIT_CENTER
    returning
      value(RV_PROFIT_CENTER) type PRCTR .
  methods GET_BUSINESS_AREA
    returning
      value(RV_BUSINESS_AREA) type GSBER .
  methods GET_MATERIAL_NUMBER
    returning
      value(RV_MATERIAL_NUMBER) type MATNR .
  methods GET_OBJECT_CLASS
    returning
      value(RV_OBJECT_CLASS) type SCOPE_CV .
  methods GET_FUNCTIONAL_AREA
    returning
      value(RV_FUNCTIONAL_AREA) type FKBER .
  methods GET_COSTING_ITEMS
    returning
      value(RT_COSTING_ITEMS) type YT_COSTING_ITEM .
  methods ADD_COSTING_ITEMS
    importing
      value(IS_COSTING_ITEMS) type zif_fco_costing_types=>YS_COSTING_ITEM .
  methods IS_ORDER_HAS_MULTIPLE_ITEMS .
  methods GET_HELPER_CLASS
    returning
      value(RO_OBJECT) type ref to zif_fco_costing_helper .
  methods SET_HELPER_CLASS
    importing
      !IO_OBJECT type ref to ZIF_FCO_COSTING_ORDER .
endinterface.
