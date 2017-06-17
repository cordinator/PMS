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
    public class GetPaymentChargesResponseDto
    {
        [DataMember]
        public int StayDays { get; set; }

        [DataMember]
        public bool IsIncludeDefaultTax { get; set; }

        [DataMember]
        public List<Tax> Tax { get; set; }
    }
}
