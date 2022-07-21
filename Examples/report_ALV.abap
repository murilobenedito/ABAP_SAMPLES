*&---------------------------------------------------------------------*
*& Report  ZVENDAS2108
*&
*&---------------------------------------------------------------------*
*& Descrição: Relatório de Vendas
*& Autor: Murilo Rodrigues Gomes Benedito Data: 21.07.2022
*&---------------------------------------------------------------------*
REPORT zvendas2108.

*&---------------------------------------------------------------------*
*& Tables
*&---------------------------------------------------------------------*
TABLES vbak.

*&---------------------------------------------------------------------*
*& Types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,
         erdat TYPE vbak-erdat,
         ernam TYPE vbak-ernam,
         posnr TYPE vbap-posnr,
         matnr TYPE vbap-matnr,
         charg TYPE vbap-charg,

  END OF ty_vbak.

*&---------------------------------------------------------------------*
*& Workarea
*&---------------------------------------------------------------------*
DATA: wa_vbak TYPE ty_vbak,
      wa_fieldcat TYPE slis_fieldcat_alv.

*&---------------------------------------------------------------------*
*& Internal Table
*&---------------------------------------------------------------------*
DATA: ti_vbak TYPE TABLE OF ty_vbak,
      ti_fieldcat TYPE slis_t_fieldcat_alv.

*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECT-OPTIONS s_erdat FOR vbak-erdat.

START-OF-SELECTION.

  PERFORM f_seleciona_dados.
  PERFORM f_preenche_fieldcat USING: 1 'VBELN' 'TI_VBAK' text-t01 10,
                                     2 'ERDAT' 'TI_VBAK' text-t02 8,
                                     3 'ERNAM' 'TI_VBAK' text-t03 12,
                                     4 'POSNR' 'TI_VBAK' text-t04 6,
                                     5 'MATNR' 'TI_VBAK' text-t05 18,
                                     6 'CHARG' 'TI_VBAK' text-t06 10.
  PERFORM f_exibe_alv.

*&---------------------------------------------------------------------*
*&      Form  F_SELECIONA_DADOS
*&---------------------------------------------------------------------*
*       Select data from table
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_seleciona_dados .

  SELECT a~vbeln
         a~erdat
         a~ernam
         b~posnr
         b~matnr
         b~charg
         FROM vbak AS a
         INNER JOIN vbap AS b
         ON a~vbeln = b~vbeln
         INTO TABLE ti_vbak
         WHERE a~erdat IN s_erdat.

ENDFORM.                    " F_SELECIONA_DADOS
*&---------------------------------------------------------------------*
*&      Form  F_PREENCHE_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      --> col_pos = p1.
*      --> fieldname = p2.
*      --> tabname = p3.
*      --> seltext_l = p4.
*      --> outputlen = p5.
*----------------------------------------------------------------------*
FORM f_preenche_fieldcat  USING p1 p2 p3 p4 p5.

  wa_fieldcat-col_pos = p1.
  wa_fieldcat-fieldname = p2.
  wa_fieldcat-tabname = p3.
  wa_fieldcat-seltext_l = p4.
  wa_fieldcat-outputlen = p5.
  APPEND wa_fieldcat TO ti_fieldcat.

ENDFORM.                    " F_PREENCHE_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  F_EXIBE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_exibe_alv .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = ti_fieldcat
    TABLES
      t_outtab      = ti_vbak
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE text-a01 TYPE 'I'.
  ENDIF.


ENDFORM.                    " F_EXIBE_ALV