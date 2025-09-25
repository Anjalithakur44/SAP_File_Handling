*&---------------------------------------------------------------------*
*& Report ZPRG_FILEHANDLING6_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_filehandling6_04.

PARAMETERS: p_dir(20) TYPE c DEFAULT '/usr/sap/trans' LOWER CASE.

DATA: lv_dir TYPE salfile-longname.

DATA: lt_files  TYPE TABLE OF salfldir,
      lwa_files TYPE salfldir.

DATA: lv_filename(50) TYPE c.

DATA: lv_string TYPE string.

DATA: lv_empid(10)   TYPE n,
      lv_empname(40) TYPE c,
      lv_empage(2)   TYPE n,
      lv_emploc(3)   TYPE c.

DATA: lt_data  TYPE TABLE OF ztemp_handle_04,
      lwa_data TYPE ztemp_handle_04.

DATA: lv_adir(70) TYPE c VALUE '/usr/sap/A4H/SYS/src'.
DATA: lv_afilename(70) TYPE c.
DATA: lv_astring TYPE string.

START-OF-SELECTION.

  lv_dir = p_dir.

  CALL FUNCTION 'RZL_READ_DIR_LOCAL' "module to display all the files of a particular directory
    EXPORTING
      name               = lv_dir
*     FROMLINE           = 0
*     NRLINES            = 1000
    TABLES
      file_tbl           = lt_files
    EXCEPTIONS
      argument_error     = 1
      not_found          = 2
      no_admin_authority = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  DELETE lt_files WHERE name NP 'EMP*'.

  LOOP AT lt_files INTO lwa_files.
    CONCATENATE p_dir '/' lwa_files-name INTO lv_filename.
    OPEN DATASET lv_filename FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.

      DO.

        READ DATASET lv_filename INTO lv_string.
        IF sy-subrc = 0.
          SPLIT lv_string AT cl_abap_char_utilities=>horizontal_tab INTO lv_empid lv_empname lv_empage lv_emploc.
          lwa_data-empid = lv_empid.
          lwa_data-empname = lv_empname.
          lwa_data-empage = lv_empage.
          lwa_data-emploc = lv_emploc.
          APPEND lwa_data TO lt_data.
          CLEAR: lwa_data.
        ELSE.
          EXIT.
        ENDIF.

      ENDDO.

      CLOSE DATASET lv_filename.

    ENDIF.

    IF lt_data IS NOT INITIAL.
      DELETE lt_data INDEX 1.
      INSERT ztemp_handle_04 FROM TABLE lt_data.
      IF sy-subrc = 0.
        MESSAGE i014(zmessage_04) WITH lwa_files-name. "file inserted successfully
      ELSE.
        MESSAGE i015(zmessage_04) WITH lwa_files-name. " problem with file
      ENDIF.

    ENDIF.

    CONCATENATE lv_adir '/' lwa_files-name INTO lv_afilename.
    OPEN DATASET lv_afilename FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      LOOP AT lt_data INTO lwa_data.
        CONCATENATE lwa_data-empid lwa_data-empname lwa_data-empage lwa_data-emploc INTO lv_astring SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
        TRANSFER lv_astring TO lv_afilename.
      ENDLOOP.
      CLOSE DATASET lv_afilename.
    ENDIF.

    DELETE DATASET lv_filename.
    REFRESH: lt_data.


  ENDLOOP.