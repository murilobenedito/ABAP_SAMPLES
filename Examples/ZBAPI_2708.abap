*&---------------------------------------------------------------------*
*& Report  ZBATCH_INPUT2708
*&
*&---------------------------------------------------------------------*
*& Descrição: Programa de Bapi
*& Autor: Murilo Rodrigues Gomes Benedito Data: 28.07.2022
*&---------------------------------------------------------------------*
REPORT zbapi2708.

*&---------------------------------------------------------------------*
*& Types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_file,
        line TYPE string,
       END OF ty_file.

*&---------------------------------------------------------------------*
*& Work Area
*&---------------------------------------------------------------------*
DATA: wa_file TYPE ty_file,
      wa_adress TYPE bapiaddr3,
      wa_adressx TYPE bapiaddr3x,
      wa_return TYPE bapiret2.

*&---------------------------------------------------------------------*
*& Internal Table
*&---------------------------------------------------------------------*
DATA: ti_file TYPE TABLE OF ty_file,
      ti_return TYPE TABLE OF bapiret2.

*&---------------------------------------------------------------------*
*& Select Screen
*&---------------------------------------------------------------------*
PARAMETERS p_file TYPE string OBLIGATORY.

*&---------------------------------------------------------------------*
*& At Selection Screen -> event
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.                          "Criar ajuda de pesquisa

  CALL FUNCTION 'GUI_FILE_LOAD_DIALOG'                                    " Carrega o path do arquivo com seletor do explore
    EXPORTING
      window_title      = 'Localizar o arquivo'
      default_extension = 'CSV'
      default_file_name = p_file
    IMPORTING
      fullpath          = p_file.
*&---------------------------------------------------------------------*
*& Start of Selection -> event
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  DATA: vl_usuario          TYPE bapibname-bapibname,
        vl_departamento(40) TYPE c.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = p_file
    TABLES
      data_tab                = ti_file
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  LOOP AT ti_file INTO wa_file.

    SPLIT wa_file-line AT ';' INTO vl_usuario
                                   vl_departamento.

    wa_adress-department = vl_departamento.
    wa_adressx-department = abap_true.

    CALL FUNCTION 'BAPI_USER_CHANGE'
      EXPORTING
        username = vl_usuario
        address  = wa_adress
        addressx = wa_adressx
      TABLES
        return   = ti_return.

    READ TABLE ti_return INTO wa_return INDEX 1.

    IF sy-subrc EQ 0 AND wa_return-type = 'S'.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

      WRITE:/1 icon_green_light AS ICON,
               wa_return-message(100).
    ELSE.

      WRITE:/1 icon_red_light AS ICON,
               wa_return-message(100).

    ENDIF.

  ENDLOOP.