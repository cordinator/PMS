﻿using PMS.Resources.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace PMS.Resources.DTO.Response
{
    [DataContract]
    [Serializable]
    public class BookingTransactionResponseDto
    {
        [DataMember]
        public List<Booking> Bookings { get; set; }
        [DataMember]
        public List<BookingSummary> BookingSummary { get; set; }
        
    }
}
