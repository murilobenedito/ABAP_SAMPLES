*&---------------------------------------------------------------------*
*& Report  ZBATCH_INPUT2708
*&
*&---------------------------------------------------------------------*
*& Descrição: Programa de Batch Input
*& Autor: Murilo Rodrigues Gomes Benedito Data: 27.07.2022
*&---------------------------------------------------------------------*
REPORT zbatch_input2708.

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
      wa_bdcdata TYPE bdcdata,
      wa_params TYPE ctu_params,
      wa_msg TYPE bdcmsgcoll.

*&---------------------------------------------------------------------*
*& Internal Table
*&---------------------------------------------------------------------*
DATA: ti_file TYPE TABLE OF ty_file,
      ti_bdcdata TYPE TABLE OF bdcdata,
      ti_msg TYPE TABLE OF bdcmsgcoll.

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

  DATA: vl_usuario(10)      TYPE c,
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

    WRITE / wa_file-line.

    SPLIT wa_file-line AT ';' INTO vl_usuario
                                   vl_departamento.

    PERFORM preenche_bdcdata USING: 'X' 'SAPLSUID_MAINTENANCE'                  '1050',
                                    ' ' 'BDC_CURSOR'                            'SUID_ST_BNAME-BNAME',
                                    ' ' 'BDC_OKCODE'                            '=CHAN',
                                    ' ' 'SUID_ST_BNAME-BNAME'                   vl_usuario.

    PERFORM preenche_bdcdata USING: 'X' 'SAPLSUID_MAINTENANCE'                  '1100',
                                    ' ' 'BDC_OKCODE'                            '=UPD',
                                    ' ' 'BDC_SUBSCR'                            'SAPLSUID_MAINTENANCE                    1900MAINAREA',
                                    ' ' 'BDC_CURSOR'                            'SUID_ST_NODE_WORKPLACE-DEPARTMENT',
                                    ' ' 'SUID_ST_NODE_WORKPLACE-DEPARTMENT'      vl_departamento.

  ENDLOOP.

  PERFORM preenche_bdcdata USING: 'X' 'SAPLSUID_MAINTENANCE'                  '1050',
                                  ' ' 'BDC_OKCODE'                            '=BACK'.

  wa_params-racommit = abap_true.
  wa_params-dismode = 'N'.        "A - visivel ou N background


  CALL TRANSACTION 'SU01' USING ti_bdcdata
                          OPTIONS FROM wa_params
                          MESSAGES INTO ti_msg.

  DATA vl_texto TYPE string.

  LOOP AT ti_msg INTO wa_msg.

    CALL FUNCTION 'MESSAGE_TEXT_BUILD'
      EXPORTING
        msgid               = wa_msg-msgid
        msgnr               = wa_msg-msgnr
        msgv1               = wa_msg-msgv1
        msgv2               = wa_msg-msgv2
        msgv3               = wa_msg-msgv3
        msgv4               = wa_msg-msgv4
      IMPORTING
        message_text_output = vl_texto.

    WRITE: / vl_texto.

  ENDLOOP.

  ULINE.
*&---------------------------------------------------------------------*
*&      Form  PREENCHE_BDCDATA
*&---------------------------------------------------------------------*
*       Preenche o BDCDATA
*----------------------------------------------------------------------*
FORM preenche_bdcdata  USING    p1
                                p2
                                p3.

  IF p1 = abap_true.
    wa_bdcdata-program    = p2.
    wa_bdcdata-dynpro     = p3.
    wa_bdcdata-dynbegin   = p1.
  ELSE.
    wa_bdcdata-fval       = p3.
    wa_bdcdata-fnam       = p2.
  ENDIF.
  APPEND wa_bdcdata TO ti_bdcdata.
  CLEAR wa_bdcdata.

ENDFORM.                    " PREENCHE_BDCDATA