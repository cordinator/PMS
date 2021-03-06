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
    
    public partial class GETINVOICEDETAILS_Result
    {
        public int InvoiceId { get; set; }
        public int GuestID { get; set; }
        public int BookingID { get; set; }
        public Nullable<bool> IsPaid { get; set; }
        public Nullable<decimal> TotalAmount { get; set; }
        public string FolioNumber { get; set; }
        public bool InvoiceActive { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedOn { get; set; }
        public string LastUpdatedBy { get; set; }
        public Nullable<System.DateTime> LastUpdatedOn { get; set; }
        public Nullable<decimal> DISCOUNT { get; set; }
        public Nullable<decimal> DISCOUNTAmount { get; set; }
        public string CreditCardDetail { get; set; }
        public string ItemName { get; set; }
        public Nullable<decimal> ItemValue { get; set; }
        public Nullable<System.DateTime> InvoiceItemCreatedOn { get; set; }
        public string PaymentMode { get; set; }
        public Nullable<decimal> PaymentValue { get; set; }
        public string PaymentDetails { get; set; }
        public Nullable<System.DateTime> InvoicePaymentCreatedOn { get; set; }
        public string TaxShortName { get; set; }
        public Nullable<decimal> TaxAmount { get; set; }
        public Nullable<decimal> TaxValue { get; set; }
        public Nullable<bool> IsConsidered { get; set; }
    }
}
