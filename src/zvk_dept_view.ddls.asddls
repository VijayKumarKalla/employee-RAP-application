@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department Root View'
@Metadata.ignorePropagatedAnnotations: true
define  view entity zvk_dept_view as select from  ytab_dept

{
   key dept_id ,
   dept_name
   
    
}   
