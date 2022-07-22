*&---------------------------------------------------------------------*
*& Report  Z_WORKING_OBJ2208
*&
*&---------------------------------------------------------------------*
*& Descrição: Programa para trabalhar com classes dentro do ABAP
*& Autor: Murilo Rodrigues Gomes Benedito Data: 22.08.2022
*&---------------------------------------------------------------------*
REPORT z_working_obj2208.

*&---------------------------------------------------------------------*
*& Class Declaration
*&---------------------------------------------------------------------*
CLASS abap_types_string DEFINITION.

  PUBLIC SECTION.
    METHODS constructor IMPORTING string_value TYPE string.

    METHODS trim RETURNING VALUE(string_value) TYPE string.

    METHODS:
            upper RETURNING VALUE(string_value) TYPE string,
            replace IMPORTING pattern TYPE string
                              replace TYPE string
                    RETURNING VALUE(string_value) TYPE string,
            get_value RETURNING VALUE(string_value) TYPE string.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS std_separador TYPE char1 VALUE '|'.

    DATA: value TYPE string.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Class Methods implementation
*&---------------------------------------------------------------------*
CLASS abap_types_string IMPLEMENTATION.

  METHOD constructor.
    me->value = string_value.
  ENDMETHOD.

  METHOD trim.
    string_value = me->value.
    CONDENSE string_value.
  ENDMETHOD.

  METHOD upper.
    string_value = me->value.
    TRANSLATE string_value TO UPPER CASE.
  ENDMETHOD.

  METHOD replace.
    string_value = me->value.
    REPLACE ALL OCCURRENCES OF pattern IN string_value WITH replace.
  ENDMETHOD.

  METHOD get_value.
    string_value = me->value.
  ENDMETHOD.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Instantiating an object referenced by the class
*&---------------------------------------------------------------------*
DATA my_string TYPE REF TO abap_types_string.

START-OF-SELECTION.

  CREATE OBJECT my_string EXPORTING string_value = 'Programando com ABAP.'.

  WRITE: / 'Trim: ', my_string->trim( ).
  WRITE: / 'Upper: ', my_string->upper( ).
  WRITE: / 'Replace: ', my_string->replace( pattern = 'ABAP' replace = 'Advanced Business Application Programming' ).
  WRITE: / 'Value: ', my_string->get_value( ).