CLASS lhc_ZI_VK_EMP_ROOT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    " *get_instance_authorizations
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_vk_emp_root RESULT result.


    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_vk_emp_root RESULT result.

    METHODS setinitialstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_vk_emp_root~setinitialstatus.

    METHODS checkage FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_vk_emp_root~checkage.

    METHODS checksalary FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_vk_emp_root~checksalary.

    METHODS approveemployee FOR MODIFY
      IMPORTING keys FOR ACTION zi_vk_emp_root~approveemployee." RESULT result.
    METHODS rejectemployee FOR MODIFY
      IMPORTING keys FOR ACTION zi_vk_emp_root~rejectemployee . "RESULT result.

ENDCLASS.


CLASS lhc_ZI_VK_EMP_ROOT IMPLEMENTATION.

  METHOD get_instance_authorizations.

    DATA(lv_cuurent_user) = sy-uname.


READ ENTITIES OF zi_vk_emp_root
  IN LOCAL MODE
  ENTITY zi_vk_emp_root
  FIELDS ( Status )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_data).

LOOP AT lt_data INTO DATA(ls).

  DATA(lv_auth) = if_abap_behv=>auth-allowed.
  DATA(lv_edit_auth)    = if_abap_behv=>auth-allowed.
  DATA(lv_auth_reject)    = if_abap_behv=>auth-allowed.

  "*************************************** Disable  approve if  already approved or in draft mode***************************************

  IF ls-Status IS  INITIAL OR  ls-Status = 'APPROVED' OR ls-%is_draft = 1 .
    lv_auth = if_abap_behv=>auth-unauthorized.
  ENDIF.


  " ***************************************Disable Edit if approved***************************************

  IF ls-Status = 'APPROVED'.
    lv_edit_auth = if_abap_behv=>auth-unauthorized.
  ENDIF.

  "***************************************Disable Rejcet if already rejected***************************************
  IF ls-Status = 'REJECTED' OR ls-%is_draft = 1 .
    lv_auth_reject =  if_abap_behv=>auth-unauthorized .
  ENDIF.
"***************************************IF other than you, no one should Approve reject or edit ************************************
  IF lv_cuurent_user  <> 'CB9980003569'.
    lv_auth = if_abap_behv=>auth-unauthorized.
    lv_auth_reject   = if_abap_behv=>auth-unauthorized.
    lv_edit_auth = if_abap_behv=>auth-unauthorized.
  ENDIF.
"*********************************************************************************************************************
  APPEND VALUE #(
    %tky = ls-%tky
     %action-Edit             =     lv_edit_auth
    %action-approveEmployee = lv_auth
    %action-rejectEmployee = lv_auth_reject

  ) TO result.

ENDLOOP.
  ENDMETHOD.
 "***************************************get_global_authorizations.
  METHOD get_global_authorizations.
  ENDMETHOD.

  "***************************************METHOD setInitialStatus

  METHOD setInitialStatus.


    DATA: lt_read   TYPE TABLE FOR READ RESULT zi_vk_emp_root,
          lt_update TYPE TABLE FOR UPDATE zi_vk_emp_root.

    READ ENTITIES OF zi_vk_emp_root
      IN LOCAL MODE
      ENTITY zi_vk_emp_root
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT lt_read.

    LOOP AT lt_read ASSIGNING FIELD-SYMBOL(<e>).

      IF <e>-Status IS INITIAL.

        APPEND VALUE #(
          %tky    = <e>-%tky
          Status  = 'NEW'

        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF zi_vk_emp_root
        IN LOCAL MODE
        ENTITY zi_vk_emp_root
        UPDATE FIELDS ( Status )
        WITH lt_update.

    ENDIF.

  ENDMETHOD.

"***************************************  METHOD checkAge.
  METHOD checkAge.

        DATA lt_data TYPE TABLE FOR READ RESULT zi_vk_emp_root.

        READ ENTITIES OF zi_vk_emp_root
          IN LOCAL MODE
          ENTITY zi_vk_emp_root
          FIELDS ( Age )
          WITH CORRESPONDING #( keys )
          RESULT lt_data.

        LOOP AT lt_data INTO DATA(ls_data).

              IF ls_data-Age < 18.

                    APPEND VALUE #(
                      %tky = ls_data-%tky
                    ) TO failed-zi_vk_emp_root.

                    APPEND VALUE #(
                      %tky = ls_data-%tky
                      %msg = new_message(
                        severity = if_abap_behv_message=>severity-error
                        id     = 'ZEMP_MSG'
                        number = '002'
                      )
                    ) TO reported-zi_vk_emp_root.

              ENDIF.

        ENDLOOP.



  ENDMETHOD.

  METHOD checkSalary.

        DATA lt_data TYPE TABLE FOR READ RESULT zi_vk_emp_root.

        READ ENTITIES OF zi_vk_emp_root
          IN LOCAL MODE
          ENTITY zi_vk_emp_root
          FIELDS ( Salary )
          WITH CORRESPONDING #( keys )
          RESULT lt_data.

    LOOP AT lt_data INTO DATA(ls_data).

          IF ls_data-Salary <= 0.

                APPEND VALUE #(
                  %tky = ls_data-%tky
                ) TO failed-zi_vk_emp_root.

                APPEND VALUE #(
                  %tky = ls_data-%tky
                  %msg = new_message(
                    severity = if_abap_behv_message=>severity-error
                    id     = 'ZEMP_MSG'
                    number = '003'
                  )
                ) TO reported-zi_vk_emp_root.

          ENDIF.

    ENDLOOP.
  ENDMETHOD.
"------------------------------------------------------------
  METHOD approveEmployee.


    DATA: lt_read   TYPE TABLE FOR READ RESULT zi_vk_emp_root,
          lt_update TYPE TABLE FOR UPDATE zi_vk_emp_root.

    " Step 1: Read current data
    READ ENTITIES OF zi_vk_emp_root
      IN LOCAL MODE
      ENTITY zi_vk_emp_root
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT lt_read.

    " Step 2: Build update payload
    LOOP AT lt_read ASSIGNING FIELD-SYMBOL(<e>).

      APPEND VALUE #(
        %tky   = <e>-%tky
        Status = 'APPROVED'
      ) TO lt_update.
  .

    ENDLOOP.

    " Step 3: Update buffer
    MODIFY ENTITIES OF zi_vk_emp_root
      IN LOCAL MODE
      ENTITY zi_vk_emp_root
      UPDATE FIELDS ( Status )
      WITH lt_update.



  ENDMETHOD.



  METHOD rejectEmployee.

  DATA: lt_read   TYPE TABLE FOR READ RESULT zi_vk_emp_root,
        lt_update TYPE TABLE FOR UPDATE zi_vk_emp_root.

  " Step 1: Read current data
  READ ENTITIES OF zi_vk_emp_root
    IN LOCAL MODE
    ENTITY zi_vk_emp_root
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT lt_read.

    " Step 2: Build update payload
    LOOP AT lt_read ASSIGNING FIELD-SYMBOL(<e>).

      APPEND VALUE #(
        %tky   = <e>-%tky
        Status = 'REJECTED'
      ) TO lt_update.

    ENDLOOP.

    " Step 3: Update buffer
    MODIFY ENTITIES OF zi_vk_emp_root
      IN LOCAL MODE
      ENTITY zi_vk_emp_root
      UPDATE FIELDS ( Status )
      WITH lt_update.

  ENDMETHOD.

ENDCLASS.
