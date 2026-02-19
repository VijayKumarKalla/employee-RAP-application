@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'emp projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_vk_emp
  as projection on ZI_VK_EMP_ROOT
{
    key EmployeeId,
    EmpName,
    Age,
    @Consumption.valueHelpDefinition: [{
  entity: {
    name: 'ZVK_DEPT_VIEW',
    element: 'dept_id'
  }
}]
    DepartmentId,
    @Semantics.amount.currencyCode: 'Currency'
    Salary,

    Status,
  StatusCriticality,
    Currency,
    created_at,
    last_changed_at,
    Approve,
    CompanyLogo,
    /* Associations */
    _Dept
}
