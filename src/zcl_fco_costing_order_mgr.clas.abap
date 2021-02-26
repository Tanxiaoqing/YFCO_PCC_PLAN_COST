class ZCL_FCO_COSTING_ORDER_MGR definition
  public
  final
  create public .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCL_FCO_COSTING_ORDER_MGR .
  methods ADD_OBJECT
    importing
      !IO_OBJECT type ref to zif_fco_costing_order .
  methods GET_OBJECT
    importing
      !IV_OBJECT_NUMBER type J_OBJNR
    returning
      value(RO_OBJECT) type ref to zif_fco_costing_order .
  methods GET_OBJECTS
    returning
      value(ET_OBJECT) type zif_fco_costing_types=>YT_PLAN_OBJECT .
  methods RESET .
  PROTECTED SECTION.
private section.

  class-data SO_INSTANCE type ref to ZCL_FCO_COSTING_ORDER_MGR .
  data MT_OBJECT type zif_fco_costing_types=>YT_PLAN_OBJECT .
ENDCLASS.



CLASS ZCL_FCO_COSTING_ORDER_MGR IMPLEMENTATION.


  METHOD ADD_OBJECT.

    CHECK io_object IS NOT INITIAL.

* First check the object instance from buffer
    READ TABLE mt_object INTO DATA(ls_object)
      WITH TABLE KEY object_number = io_object->get_object_number( ).
    IF sy-subrc <> 0.
* Put newly created object instance into buffer
      ls_object-object_number = io_object->get_object_number( ).
"      ls_object-object = io_object.
      INSERT ls_object INTO TABLE mt_object.
    ENDIF.

  ENDMETHOD.


  METHOD GET_INSTANCE.
    IF so_instance IS INITIAL.
      CREATE OBJECT so_instance.
    ENDIF.

    ro_instance = so_instance.

  ENDMETHOD.


  METHOD GET_OBJECT.
    READ TABLE mt_object INTO DATA(ls_object)
      WITH TABLE KEY object_number = iv_object_number.
"    ro_object = ls_object-object.
  ENDMETHOD.


  METHOD GET_OBJECTS.
    et_object = mt_object.
  ENDMETHOD.


  METHOD RESET.
    REFRESH mt_object.
  ENDMETHOD.
ENDCLASS.
