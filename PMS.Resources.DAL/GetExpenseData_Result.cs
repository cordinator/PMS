
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------


namespace PMS.Resources.DAL
{

using System;
    
public partial class GetExpenseData_Result
{

    public int ID { get; set; }

    public Nullable<int> PropertyID { get; set; }

    public Nullable<int> ExpenseCategoryID { get; set; }

    public Nullable<int> PaymentTypeID { get; set; }

    public Nullable<decimal> Amount { get; set; }

    public string Description { get; set; }

    public Nullable<bool> IsActive { get; set; }

    public Nullable<System.DateTime> ExpenseDate { get; set; }

    public Nullable<System.DateTime> CreatedOn { get; set; }

    public string CreatedBy { get; set; }

    public string LastUpdatedBy { get; set; }

    public Nullable<System.DateTime> LastUpdatedOn { get; set; }

    public string PaymentShortName { get; set; }

    public string PaymentDesc { get; set; }

    public string CategoryShortName { get; set; }

    public string CategoryDesc { get; set; }

}

}
