*&---------------------------------------------------------------------*
*& Report ZPRG_FILEHANDLING7_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_filehandling7_04.

DATA: lv_filename TYPE string.

lv_filename = '/usr/sap/A4H/SYS/src/Emp_BLR_24092025.txt'.  " file path

DELETE DATASET lv_filename.

IF sy-subrc = 0.
  WRITE: / 'File deleted successfully:', lv_filename.
ELSE.
  WRITE: / 'Error deleting file:', lv_filename.
ENDIF.