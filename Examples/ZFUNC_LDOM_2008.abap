*&---------------------------------------------------------------------*
*& Report  ZFUNC_LDOM_2008
*&
*&---------------------------------------------------------------------*
*& Descrição: Retorna o Ultimo dia do mês
*& Autor: Murilo Rodrigues Gomes Benedito Data: 21.07.2022
*&---------------------------------------------------------------------*
REPORT zfunc_ldom_2008.

PARAMETERS p_today TYPE sy-datum.

DATA v_lastday TYPE sy-datum.
DATA v_weekday TYPE dtresr-weekday.

START-OF-SELECTION.

  PERFORM f_retorna_ultimo_dia_mes USING p_today.
  PERFORM f_retorna_dia_semana USING v_lastday.

  WRITE: TEXT-t01, v_lastday, /, TEXT-t02, v_weekday.

*&---------------------------------------------------------------------*
*&      Form  F_RETORNA_ULTIMO_DIA_MES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_retorna_ultimo_dia_mes USING p1.

  CALL FUNCTION 'LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = p1
    IMPORTING
      last_day_of_month = v_lastday
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.                    " F_RETORNA_ULTIMO_DIA_MES
*&---------------------------------------------------------------------*
*&      Form  F_RETORNA_DIA_SEMANA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_V_LASTDAY  text
*----------------------------------------------------------------------*
FORM f_retorna_dia_semana  USING    p_v_lastday.

  CALL FUNCTION 'DATE_TO_DAY'
    EXPORTING
      date    = p_v_lastday
    IMPORTING
      weekday = v_weekday.


ENDFORM.                    " F_RETORNA_DIA_SEMANA