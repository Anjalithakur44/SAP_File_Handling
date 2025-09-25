*&---------------------------------------------------------------------*
*& Report ZPRG_FILEHANDLING4_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_filehandling4_04.

DATA: lv_ono TYPE zdeono_04.
SELECT-OPTIONS: s_ono FOR lv_ono.

TYPES: BEGIN OF lty_data,
         ono    TYPE zdeono_04,
         odate  TYPE zdeodate_04,
         pm     TYPE zdepm_04,
         ta(10) TYPE c,
       END OF lty_data.

DATA: lt_data  TYPE TABLE OF lty_data,
      lwa_data TYPE lty_data.

DATA: lv_filepath(20) TYPE c VALUE '/tmp/order.txt'.
DATA: lv_string TYPE string.

OPEN DATASET lv_filepath FOR INPUT IN TEXT MODE ENCODING DEFAULT.
IF sy-subrc = 0.
  DO.
    READ DATASET lv_filepath INTO lv_string.
    IF sy-subrc = 0.
      SPLIT lv_string AT ' ' INTO lwa_data-ono lwa_data-odate lwa_data-pm lwa_data-ta.
      APPEND lwa_data TO lt_data.
      CLEAR: lwa_data.
    ELSE.
      EXIT.
    ENDIF.
  ENDDO.
CLOSE DATASET lv_filepath.
ENDIF.

LOOP AT lt_data INTO lwa_data.
  WRITE: / lwa_data-ono, lwa_data-odate, lwa_data-pm, lwa_data-ta.
ENDLOOP.