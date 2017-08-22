﻿using PMS.Resources.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace PMS.Resources.DTO.Request
{
    [DataContract]
    [Serializable]
    public class BookingTransactionRequestDto
    {
        [DataMember]
        public int PropertyId { get; set; }
        [DataMember]
        public DateTime StartDate {get;set;}
        [DataMember]
        public DateTime EndDate {get;set;}
        [DataMember]
        public String GuestName {get;set;}
        [DataMember]
        public String RoomType {get;set;}
        [DataMember]
        public decimal AmountPaid {get;set;}
        [DataMember]
        public String PaymentMode {get;set;}
        [DataMember]
        public bool TransactionStatus {get;set;}
    }
}
