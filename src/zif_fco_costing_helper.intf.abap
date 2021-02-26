interface ZIF_FCO_COSTING_HELPER
  public .


  data MO_OBJECT type ref to zif_fco_costing_order .
  methods CALCULATE_PREPLAN_COST
    importing
      !IS_KEKO type KEKO
      !IV_QUANTITY type CKI64A-USR_MENGE
      !IV_UNIT type MEINS
      !IV_COST_COMPONENT_VIEW type CK_SICHT
      !IT_KIS1 type CKF_STANDARD_KIS1_TABLE
    exporting
      !ET_PREPLAN_COST type CKF_STANDARD_KIS1_TABLE
    raising
      CX_FCO_PCC_EXCEPTION .

  methods GET_ORDER_OPERATION
    importing
      !IV_ORDER_NUMBER type AUFNR
      !IV_OPERATION_NUMBER type VORNR
    exporting
      !ES_ORDER_OPERATION type AFVGD
    raising
      CX_FCO_PCC_EXCEPTION .
  methods GET_COST_COMPONENT_VIEW
    importing
      !IV_VIEW_NAME type STRING
      !IS_KEKO type KEKO
    exporting
      !EV_COST_COMPONENT_VIEW type CK_SICHT
    raising
      CX_FCO_PCC_EXCEPTION .
  methods GET_COST_ESTIMATE_ACTIVE_VERS
    importing
      !IV_MATERIAL type MATNR
      !IV_PLANT type WERKS_D
      !IV_COSTING_DATE type SY-DATLO
    exporting
      !ES_KEKO type KEKO
    raising
      CX_FCO_PCC_EXCEPTION .
  methods GET_COST_ESTIMATE
    importing
      !IS_KEKO type KEKO
    exporting
      !ES_KHS1 type KHS1
      !ET_KIS1 type CKF_STANDARD_KIS1_TABLE
    raising
      CX_FCO_PCC_EXCEPTION .
  methods GET_CONTROLLING_AREA_DATA
    importing
      !IV_KOKRS type KOKRS
    exporting
      value(ES_TKA01) type TKA01
    raising
      CX_FCO_PCC_EXCEPTION .
  methods GET_ACTIVITY_TYPE_BASE_UNIT
    importing
      !IV_FISCAL_YEAR type GJAHR
      !IV_CONTROLLING_AREA type KOKRS
      !IV_COST_CENTER type KOSTL
      !IV_ACTIVITY_TYPE type LSTAR
    exporting
      !EV_UNIT_OF_MEASURE type MEINS
    raising
      CX_FCO_PCC_EXCEPTION .

  methods GET_DEBIT_CREDIT_INDICATOR
    importing
      !IV_ITEM_CATEGORY type TYPPS
      !IV_ITEM_QTY type MENGE_POS
      !IV_ITEM_AMOUNT type CK_KWT
    exporting
      !EV_CREDIT_DEBIT_INDICATOR type FINS_CO_BELKZ .
  methods GET_BUS_TRANS_TYPE_FRM_COSTCAT
    importing
      !IV_DATE type DATUM
      !IV_CONTROLLING_AREA type KOKRS
      !IV_GL_ACCOUNT type RACCT
      !IV_PARTNER_OBJECT type PAROB
    exporting
      !EV_BUSINESS_TRANS_TYPE type FINS_BTTYPE
    raising
      CX_FCO_PCC_EXCEPTION .
  methods GET_PLAN_CATEGORY
    importing
      !IV_CATEGORY_NAME type STRING
    returning
      value(RV_PLAN_CATEGORY) type FCOM_CATEGORY
    raising
      CX_FCO_PCC_EXCEPTION .
  methods CALCULATE_TARGET_COST_TAB
    importing
      !IV_COSTING_SIZE type VQUAN1_12
      !IV_OUTPUT_QUANTITY type VQUAN1_12
      !IT_KALKTAB type CKF_STANDARD_KALKTAB_TABLE
    exporting
      !ET_TARGET_COST type CKF_STANDARD_KALKTAB_TABLE .
  methods CALC_TARGET_COST_AT_COST_EST
    importing
      !IS_COSTING_HEADER type CKIBEW
      !IS_COSTING_OBJECT type CKCOUEB
      !IS_COSTING_ORDER type CAUFVD
      !IV_MATERIAL type MATNR
      !IV_OUTPUT_UNIT type RVUNIT
      !IV_OUTPUT_QUANTITY type VQUAN1_12
    exporting
      !ET_KIS1 type CKF_STANDARD_KIS1_TABLE
      !ET_TARGET_COST type CKF_STANDARD_KALKTAB_TABLE
      !ES_KEKO type KEKO
      !EV_COSTING_SIZE type VQUAN1_12
    raising
      CX_FCO_PCC_EXCEPTION .
  methods CALCULATE_OVERHEAD
    importing
      !IS_COSTING_HEADER type CKIBEW
      !IS_COSTING_OBJECT type CKCOUEB
      !IT_KALKTAB type CKF_STANDARD_KALKTAB_TABLE
    exporting
      !ET_OVERHEAD type CKF_STANDARD_KALKTAB_TABLE .
  methods CALC_AND_AGGR_OVERHEAD
    importing
      !IS_COSTING_HEADER type CKIBEW
      !IS_COSTING_OBJECT type CKCOUEB
      !IT_KALKTAB type CKF_STANDARD_KALKTAB_TABLE
      !IB_CURRENT_DATE_AS_OH_DATE type BOOLE_D default ABAP_TRUE
    exporting
      !ET_OVERHEAD type CKF_STANDARD_KALKTAB_TABLE .
  methods FILTER_OVERHEAD
    importing
      !IV_PLANT type WERKS_D
      !IV_CHART_OF_ACCOUNT type KTOPL
      !IV_COST_COMPONENT_STRUCTURE type CK_ELESMHK
      !IT_OVERHEAD type CKF_STANDARD_KALKTAB_TABLE
    exporting
      !ET_OVERHEAD type CKF_STANDARD_KALKTAB_TABLE
    raising
      CX_FCO_PCC_EXCEPTION .
  methods DERIVE_ACDOCP_ITEM
    importing
      !IV_OBJECT_NUMBER type J_OBJNR
      !IS_COSTING_ITEM type zif_fco_costing_types=>YS_COSTING_ITEM
    changing
      !CS_PLAN_COST type FINS_PLAN_API_PLANDATA_INT .
endinterface.
