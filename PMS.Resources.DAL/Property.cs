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
    using System.Collections.Generic;
    
    public partial class Property
    {
        public Property()
        {
            this.Bookings = new HashSet<Booking>();
            this.ExtraCharges = new HashSet<ExtraCharge>();
            this.Rates = new HashSet<Rate>();
            this.RateTypes = new HashSet<RateType>();
            this.RateTypes1 = new HashSet<RateType>();
            this.Rooms = new HashSet<Room>();
            this.RoomPricings = new HashSet<RoomPricing>();
            this.RoomTypes = new HashSet<RoomType>();
            this.Taxes = new HashSet<Tax>();
        }
    
        public int ID { get; set; }
        public string PropertyDetails { get; set; }
        public bool IsActive { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedOn { get; set; }
        public string LastUpdatedBy { get; set; }
        public Nullable<System.DateTime> LastUpdatedOn { get; set; }
        public string PropertyName { get; set; }
        public string SecondaryName { get; set; }
        public string PropertyCode { get; set; }
        public string FullAddress { get; set; }
        public string Phone { get; set; }
        public string Fax { get; set; }
        public string LogoPath { get; set; }
        public string WebSiteAddress { get; set; }
        public string TimeZone { get; set; }
        public Nullable<int> CurrencyID { get; set; }
        public Nullable<System.TimeSpan> CheckinTime { get; set; }
        public Nullable<System.TimeSpan> CheckoutTime { get; set; }
        public Nullable<System.TimeSpan> CloseOfDayTime { get; set; }
    
        public virtual ICollection<Booking> Bookings { get; set; }
        public virtual ICollection<ExtraCharge> ExtraCharges { get; set; }
        public virtual ICollection<Rate> Rates { get; set; }
        public virtual ICollection<RateType> RateTypes { get; set; }
        public virtual ICollection<RateType> RateTypes1 { get; set; }
        public virtual ICollection<Room> Rooms { get; set; }
        public virtual ICollection<RoomPricing> RoomPricings { get; set; }
        public virtual ICollection<RoomType> RoomTypes { get; set; }
        public virtual ICollection<Tax> Taxes { get; set; }
    }
}
