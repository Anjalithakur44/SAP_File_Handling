*&---------------------------------------------------------------------*
*& Report ZPRG_FILEHANDLING3_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_filehandling3_04.

DATA: lv_ono TYPE zdeono_04.
SELECT-OPTIONS: s_ono FOR lv_ono.

TYPES: BEGIN OF lty_data,
         ono   TYPE zdeono_04,
         odate TYPE zdeodate_04,
         pm    TYPE zdepm_04,
         ta    TYPE zdetc_04,
       END OF lty_data.

DATA: lt_data  TYPE TABLE OF lty_data,
      lwa_data TYPE lty_data.

DATA: lv_filepath(20) TYPE c VALUE '/tmp/order.txt'. "Path for AL11 Directory TMP

DATA: lv_string TYPE string.
DATA: lv_amount(10) TYPE c.

SELECT ono odate pm ta
  FROM zordh_04
  INTO TABLE lt_data
  WHERE ono IN s_ono.

OPEN DATASET lv_filepath FOR OUTPUT IN TEXT MODE ENCODING DEFAULT. "opening file in text mode for writing data
IF sy-subrc = 0.

  LOOP AT lt_data INTO lwa_data.
    WRITE lwa_data-ta TO lv_amount. "writing amount in char type since concatenate doesnt work for amount type(curr)
    CONCATENATE lwa_data-ono lwa_data-odate lwa_data-pm lv_amount INTO lv_string SEPARATED BY ' '.
    TRANSFER lv_string TO lv_filepath.
  ENDLOOP.

  CLOSE DATASET lv_filepath.

ENDIF.