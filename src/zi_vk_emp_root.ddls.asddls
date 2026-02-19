@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_VK_EMP_ROOT as select from zvk_emp
//composition of target_data_source_name as _association_name
association[1..1] to zvk_dept_view  as _Dept on $projection.DepartmentId = _Dept.dept_id
{
key employee_id as EmployeeId,
emp_name as EmpName,
age as Age,
@Consumption.valueHelpDefinition: [{
  entity: {
    name: 'ZVK_DEPT_VIEW',
    element: 'dept_id'
  }
}]
dept_id as DepartmentId,
@Semantics.amount.currencyCode: 'Currency'
salary as Salary,

status as Status,
case status
      when 'APPROVED' then 3
      when 'REJECTED' then 1
      else 2
    end as StatusCriticality,
    
    'Approve Employee' as Approve,
    
currency as Currency,
 @Semantics.systemDateTime.createdAt: true
      created_at,
 @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,
      @Semantics.imageUrl: true
cast(
  'https://raw.githubusercontent.com/VijayKumarKalla/rap-employee-app/main/Illustration-of-logo-design-template-on-transparent-background-PNG.png'
  as abap.char(255)
) as CompanyLogo,
      
    
    //_association_name // Make association public
    _Dept
}
