﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class PmsEntities : DbContext
    {
        public PmsEntities()
            : base("name=PmsEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<AdditionalGuest> AdditionalGuests { get; set; }
        public virtual DbSet<Address> Addresses { get; set; }
        public virtual DbSet<AddressType> AddressTypes { get; set; }
        public virtual DbSet<Booking> Bookings { get; set; }
        public virtual DbSet<ChargableFacility> ChargableFacilities { get; set; }
        public virtual DbSet<City> Cities { get; set; }
        public virtual DbSet<Country> Countries { get; set; }
        public virtual DbSet<Currency> Currencies { get; set; }
        public virtual DbSet<ExtraCharge> ExtraCharges { get; set; }
        public virtual DbSet<Guest> Guests { get; set; }
        public virtual DbSet<GuestMapping> GuestMappings { get; set; }
        public virtual DbSet<GuestReward> GuestRewards { get; set; }
        public virtual DbSet<IDType> IDTypes { get; set; }
        public virtual DbSet<Invoice> Invoices { get; set; }
        public virtual DbSet<InvoiceItem> InvoiceItems { get; set; }
        public virtual DbSet<InvoicePaymentDetail> InvoicePaymentDetails { get; set; }
        public virtual DbSet<InvoiceTaxDetail> InvoiceTaxDetails { get; set; }
        public virtual DbSet<PaymentType> PaymentTypes { get; set; }
        public virtual DbSet<Property> Properties { get; set; }
        public virtual DbSet<PropertyFloor> PropertyFloors { get; set; }
        public virtual DbSet<Rate> Rates { get; set; }
        public virtual DbSet<RateType> RateTypes { get; set; }
        public virtual DbSet<RewardCategory> RewardCategories { get; set; }
        public virtual DbSet<Room> Rooms { get; set; }
        public virtual DbSet<RoomBooking> RoomBookings { get; set; }
        public virtual DbSet<RoomPricing> RoomPricings { get; set; }
        public virtual DbSet<RoomType> RoomTypes { get; set; }
        public virtual DbSet<State> States { get; set; }
        public virtual DbSet<Tax> Taxes { get; set; }
    
        public virtual ObjectResult<GETALLBOOKINGS_Result> GETALLBOOKINGS(Nullable<int> pROPERTYID, Nullable<System.DateTime> cHECKINTIME, Nullable<System.DateTime> cHECKOUTDATE)
        {
            var pROPERTYIDParameter = pROPERTYID.HasValue ?
                new ObjectParameter("PROPERTYID", pROPERTYID) :
                new ObjectParameter("PROPERTYID", typeof(int));
    
            var cHECKINTIMEParameter = cHECKINTIME.HasValue ?
                new ObjectParameter("CHECKINTIME", cHECKINTIME) :
                new ObjectParameter("CHECKINTIME", typeof(System.DateTime));
    
            var cHECKOUTDATEParameter = cHECKOUTDATE.HasValue ?
                new ObjectParameter("CHECKOUTDATE", cHECKOUTDATE) :
                new ObjectParameter("CHECKOUTDATE", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GETALLBOOKINGS_Result>("GETALLBOOKINGS", pROPERTYIDParameter, cHECKINTIMEParameter, cHECKOUTDATEParameter);
        }
    
        public virtual ObjectResult<GETALLGUESTS_Result> GETALLGUESTS()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GETALLGUESTS_Result>("GETALLGUESTS");
        }
    
        public virtual ObjectResult<GETBOOKINGAMOUNT_Result> GETBOOKINGAMOUNT(Nullable<int> pROPERTYID, Nullable<int> rOOMTYPEID, Nullable<int> rATETYPEID, Nullable<int> nOOFHOURS, Nullable<int> nOOFDAYS, Nullable<bool> iSHOURLY)
        {
            var pROPERTYIDParameter = pROPERTYID.HasValue ?
                new ObjectParameter("PROPERTYID", pROPERTYID) :
                new ObjectParameter("PROPERTYID", typeof(int));
    
            var rOOMTYPEIDParameter = rOOMTYPEID.HasValue ?
                new ObjectParameter("ROOMTYPEID", rOOMTYPEID) :
                new ObjectParameter("ROOMTYPEID", typeof(int));
    
            var rATETYPEIDParameter = rATETYPEID.HasValue ?
                new ObjectParameter("RATETYPEID", rATETYPEID) :
                new ObjectParameter("RATETYPEID", typeof(int));
    
            var nOOFHOURSParameter = nOOFHOURS.HasValue ?
                new ObjectParameter("NOOFHOURS", nOOFHOURS) :
                new ObjectParameter("NOOFHOURS", typeof(int));
    
            var nOOFDAYSParameter = nOOFDAYS.HasValue ?
                new ObjectParameter("NOOFDAYS", nOOFDAYS) :
                new ObjectParameter("NOOFDAYS", typeof(int));
    
            var iSHOURLYParameter = iSHOURLY.HasValue ?
                new ObjectParameter("ISHOURLY", iSHOURLY) :
                new ObjectParameter("ISHOURLY", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GETBOOKINGAMOUNT_Result>("GETBOOKINGAMOUNT", pROPERTYIDParameter, rOOMTYPEIDParameter, rATETYPEIDParameter, nOOFHOURSParameter, nOOFDAYSParameter, iSHOURLYParameter);
        }
    
        public virtual ObjectResult<GetBookingDetails_Result> GetBookingDetails(Nullable<int> bookingID)
        {
            var bookingIDParameter = bookingID.HasValue ?
                new ObjectParameter("BookingID", bookingID) :
                new ObjectParameter("BookingID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GetBookingDetails_Result>("GetBookingDetails", bookingIDParameter);
        }
    
        public virtual ObjectResult<GETGUESTTRANSACTIONS_Result> GETGUESTTRANSACTIONS(Nullable<int> gUESTID)
        {
            var gUESTIDParameter = gUESTID.HasValue ?
                new ObjectParameter("GUESTID", gUESTID) :
                new ObjectParameter("GUESTID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GETGUESTTRANSACTIONS_Result>("GETGUESTTRANSACTIONS", gUESTIDParameter);
        }
    
        public virtual ObjectResult<GETINVOICEDETAILS_Result> GETINVOICEDETAILS(Nullable<int> iNVOICEID)
        {
            var iNVOICEIDParameter = iNVOICEID.HasValue ?
                new ObjectParameter("INVOICEID", iNVOICEID) :
                new ObjectParameter("INVOICEID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GETINVOICEDETAILS_Result>("GETINVOICEDETAILS", iNVOICEIDParameter);
        }
    
        public virtual ObjectResult<GETROOMSTATUS_Result> GETROOMSTATUS(Nullable<int> pROPERTYID, Nullable<System.DateTime> cHECKINTIME, Nullable<System.DateTime> cHECKOUTDATE)
        {
            var pROPERTYIDParameter = pROPERTYID.HasValue ?
                new ObjectParameter("PROPERTYID", pROPERTYID) :
                new ObjectParameter("PROPERTYID", typeof(int));
    
            var cHECKINTIMEParameter = cHECKINTIME.HasValue ?
                new ObjectParameter("CHECKINTIME", cHECKINTIME) :
                new ObjectParameter("CHECKINTIME", typeof(System.DateTime));
    
            var cHECKOUTDATEParameter = cHECKOUTDATE.HasValue ?
                new ObjectParameter("CHECKOUTDATE", cHECKOUTDATE) :
                new ObjectParameter("CHECKOUTDATE", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<GETROOMSTATUS_Result>("GETROOMSTATUS", pROPERTYIDParameter, cHECKINTIMEParameter, cHECKOUTDATEParameter);
        }
    
        public virtual ObjectResult<InsertBooking_Result> InsertBooking(Nullable<int> propertyID, string bookingXML, ObjectParameter bOOKINGID, ObjectParameter gUESTID)
        {
            var propertyIDParameter = propertyID.HasValue ?
                new ObjectParameter("propertyID", propertyID) :
                new ObjectParameter("propertyID", typeof(int));
    
            var bookingXMLParameter = bookingXML != null ?
                new ObjectParameter("bookingXML", bookingXML) :
                new ObjectParameter("bookingXML", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<InsertBooking_Result>("InsertBooking", propertyIDParameter, bookingXMLParameter, bOOKINGID, gUESTID);
        }
    
        public virtual ObjectResult<Nullable<int>> InsertInvoice(Nullable<int> propertyID, string invoiceXML, ObjectParameter iNVOICEID)
        {
            var propertyIDParameter = propertyID.HasValue ?
                new ObjectParameter("propertyID", propertyID) :
                new ObjectParameter("propertyID", typeof(int));
    
            var invoiceXMLParameter = invoiceXML != null ?
                new ObjectParameter("InvoiceXML", invoiceXML) :
                new ObjectParameter("InvoiceXML", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<Nullable<int>>("InsertInvoice", propertyIDParameter, invoiceXMLParameter, iNVOICEID);
        }
    
        public virtual int UpdateBooking(Nullable<int> bOOKINGID, Nullable<System.DateTime> cHECKINTIME, Nullable<System.DateTime> cHECKOUTTIME, Nullable<int> roomID)
        {
            var bOOKINGIDParameter = bOOKINGID.HasValue ?
                new ObjectParameter("BOOKINGID", bOOKINGID) :
                new ObjectParameter("BOOKINGID", typeof(int));
    
            var cHECKINTIMEParameter = cHECKINTIME.HasValue ?
                new ObjectParameter("CHECKINTIME", cHECKINTIME) :
                new ObjectParameter("CHECKINTIME", typeof(System.DateTime));
    
            var cHECKOUTTIMEParameter = cHECKOUTTIME.HasValue ?
                new ObjectParameter("CHECKOUTTIME", cHECKOUTTIME) :
                new ObjectParameter("CHECKOUTTIME", typeof(System.DateTime));
    
            var roomIDParameter = roomID.HasValue ?
                new ObjectParameter("RoomID", roomID) :
                new ObjectParameter("RoomID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("UpdateBooking", bOOKINGIDParameter, cHECKINTIMEParameter, cHECKOUTTIMEParameter, roomIDParameter);
        }
    }
}
