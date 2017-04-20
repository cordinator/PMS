﻿using PMS.Resources.Common.Constants;
using PMS.Resources.Core;
using PMS.Resources.DTO.Request;
using PMS.Resources.DTO.Response;
using PMS.Resources.Logging.CustomException;
using PMS.Resources.Logic;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace PMS.Api.Controllers
{
    public partial class RoomController : ApiController, IRestController
    {
        private void MapHttpRoutesForRoomStatus(HttpConfiguration config)
        {
            config.Routes.MapHttpRoute(
            "AddRoomStatus",
            "api/v1/Room/AddRoomStatus",
            new { controller = "Room", action = "AddRoomStatus" }
            );

            config.Routes.MapHttpRoute(
             "UpdateRoomStatus",
             "api/v1/Room/UpdateRoomStatus",
             new { controller = "Room", action = "UpdateRoomStatus" }
             );

            config.Routes.MapHttpRoute(
             "DeleteRoomStatus",
             "api/v1/Room/DeleteRoomStatus/{statusId}",
             new { controller = "Room", action = "DeleteRoomStatus" },
             constraints: new { statusId = RegExConstants.NumericRegEx }
             );

            config.Routes.MapHttpRoute(
             "GetRoomStatus",
             "api/v1/Room/GetRoomStatus",
             new { controller = "Room", action = "GetRoomStatus" }
             );

            config.Routes.MapHttpRoute(
              "GetRoomStatusById",
              "api/v1/Room/GetRoomStatusById/{statusId}",
              new { controller = "Room", action = "GetRoomStatusById" },
              constraints: new { statusId = RegExConstants.NumericRegEx }
              );
        }

        [HttpPost, ActionName("AddRoomStatus")]
        public PmsResponseDto AddRoomStatus([FromBody] AddRoomStatusRequestDto request)
        {
            if (request == null || request.RoomStatus == null) throw new PmsException("Room status can not be added.");

            var response = new PmsResponseDto();
            return response;
        }

        [HttpPut, ActionName("UpdateRoomStatus")]
        public PmsResponseDto UpdateRoomStatus([FromBody] UpdateRoomStatusRequestDto request)
        {
            if (request == null || request.RoomStatus == null || request.RoomStatus.Id <= 0) throw new PmsException("Room status can not be updated.");

            var response = new PmsResponseDto();
            return response;
        }

        [HttpDelete, ActionName("DeleteRoomStatus")]
        public PmsResponseDto DeleteRoomStatus(int statusId)
        {
            if (statusId <= 0) throw new PmsException("Roomstatusid is not valid. Hence Roomstatus can not be deleted.");

            var response = new PmsResponseDto();
            return response;
        }

        [HttpGet, ActionName("GetRoomStatus")]
        public GetRoomStatusResponseDto GetRoomStatus()
        {
            var response = new GetRoomStatusResponseDto();
            return response;
        }

        [HttpGet, ActionName("GetRoomStatusById")]
        public GetRoomStatusResponseDto GetRoomStatusById(int statusId)
        {
            var response = new GetRoomStatusResponseDto();
            if (statusId <= 0)
            {
                return response;
            }
            return response;
        }      
    }
}