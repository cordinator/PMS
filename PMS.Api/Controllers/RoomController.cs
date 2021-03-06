﻿using PMS.Resources.Common.Constants;
using PMS.Resources.Common.Helper;
using PMS.Resources.Core;
using PMS.Resources.DTO.Request;
using PMS.Resources.DTO.Response;
using PMS.Resources.Entities;
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
    [Export(typeof(IRestController))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public partial class RoomController : ApiController, IRestController
    {
        private readonly IPmsLogic _iPmsLogic = null;
        public RoomController()
            : this(ServiceLocator.Current.GetInstance<IPmsLogic>())
        {
            
        }

        public RoomController(IPmsLogic iPmsLogic)
        {
            _iPmsLogic = iPmsLogic;
        }

        /// <summary>
        /// Map Routes for REST
        /// </summary>
        /// <param name="config"></param>
        [System.Web.Http.NonAction]
        public void MapHttpRoutes(HttpConfiguration config)
        {
            MapHttpRoutesForRoom(config);
            MapHttpRoutesForRoomType(config);
            MapHttpRoutesForRoomStatus(config);
            MapHttpRoutesForRateType(config);
            MapHttpRoutesForRoomPricing(config);
        }

        private void MapHttpRoutesForRoom(HttpConfiguration config)
        {
            config.Routes.MapHttpRoute(
             "AddRoom",
             "api/v1/Room/AddRoom",
             new { controller = "Room", action = "AddRoom" }
             );

            config.Routes.MapHttpRoute(
             "UpdateRoom",
             "api/v1/Room/UpdateRoom",
             new { controller = "Room", action = "UpdateRoom" }
             );

            config.Routes.MapHttpRoute(
             "DeleteRoom",
             "api/v1/Room/DeleteRoom/{roomId}",
             new { controller = "Room", action = "DeleteRoom" },
             constraints: new { roomId = RegExConstants.NumericRegEx }
             );

            config.Routes.MapHttpRoute(
              "GetRoomByProperty",
              "api/v1/Room/GetRoomByProperty/{propertyId}",
              new { controller = "Room", action = "GetRoomByProperty" },
              constraints: new { propertyId = RegExConstants.NumericRegEx }
              );

            config.Routes.MapHttpRoute(
            "GetRoomById",
            "api/v1/Room/{propertyId}/GetRoomById/{roomId}",
            new { controller = "Room", action = "GetRoomById" },
            constraints: new { propertyId = RegExConstants.NumericRegEx, roomId = RegExConstants.NumericRegEx }
            );
           
            config.Routes.MapHttpRoute(
            "GetRoomByRoomType",
            "api/v1/Room/{propertyId}/GetRoomByRoomType/{typeId}",
            new { controller = "Room", action = "GetRoomByRoomType" },
            constraints: new { propertyId = RegExConstants.NumericRegEx, typeId = RegExConstants.NumericRegEx }
            );

            config.Routes.MapHttpRoute(
             "GetRoomByStatus",
             "api/v1/Room/{propertyId}/GetRoomByStatus/{statusId}",
             new { controller = "Room", action = "GetRoomByStatus" },
             constraints: new { propertyId = RegExConstants.NumericRegEx, statusId = RegExConstants.NumericRegEx }
             );

            config.Routes.MapHttpRoute(
            "GetRoomByRoomNumber",
            "api/v1/Room/{propertyId}/GetRoomByRoomNumber/{roomNumber}",
            new { controller = "Room", action = "GetRoomByRoomNumber" },
            constraints: new { propertyId = RegExConstants.NumericRegEx, roomNumber = RegExConstants.AlphaNumericRegEx }
            );

            config.Routes.MapHttpRoute(
            "GetRoomByDate",
            "api/v1/Room/GetRoomByDate",
            new { controller = "Room", action = "GetRoomByDate" }
            );
        }

        [HttpPost, ActionName("AddRoom")]
        public PmsResponseDto AddRoom([FromBody] AddRoomRequestDto request)
        {
            if (request == null || request.Rooms == null || request.Rooms.Count <= 0) throw new PmsException("Room can not be added.");

            var response = new PmsResponseDto();
            if (_iPmsLogic.AddRoom(request.Rooms))
            {
                response.ResponseStatus = PmsApiStatus.Success.ToString();
                response.StatusDescription = "Record(s) saved successfully.";
            }
            else
            {
                response.ResponseStatus = PmsApiStatus.Failure.ToString();
                response.StatusDescription = "Operation failed.Please contact administrator.";
            }
            return response;
        }

        [HttpPut, ActionName("UpdateRoom")]
        public PmsResponseDto UpdateRoom([FromBody] UpdateRoomRequestDto request)
        {
            if (request == null || request.Rooms == null || request.Rooms.Count <= 0) throw new PmsException("Room can not be updated.");

            var response = new PmsResponseDto();
            if (_iPmsLogic.UpdateRoom(request.Rooms))
            {
                response.ResponseStatus = PmsApiStatus.Success.ToString();
                response.StatusDescription = "Record(s) saved successfully.";
            }
            else
            {
                response.ResponseStatus = PmsApiStatus.Failure.ToString();
                response.StatusDescription = "Operation failed.Please contact administrator.";
            }
            return response;
        }

        [HttpDelete, ActionName("DeleteRoom")]
        public PmsResponseDto DeleteRoom(int roomId)
        {
            if (roomId <= 0) throw new PmsException("Roomid is not valid. Hence Room can not be deleted.");

            var response = new PmsResponseDto();
            if (_iPmsLogic.DeleteRoom(roomId))
            {
                response.ResponseStatus = PmsApiStatus.Success.ToString();
                response.StatusDescription = "Record deleted successfully.";
            }
            else
            {
                response.ResponseStatus = PmsApiStatus.Failure.ToString();
                response.StatusDescription = "Operation failed.Please contact administrator.";
            }
            return response;
        }

        [HttpGet, ActionName("GetRoomByProperty")]
        public GetRoomResponseDto GetRoomByProperty(int propertyId)
        {
            if (propertyId <= 0) throw new PmsException("Property id is not valid.");

            var response = new GetRoomResponseDto();
            if (!AppConfigReaderHelper.AppConfigToBool(AppSettingKeys.MockEnabled))
            {
                response.Rooms = _iPmsLogic.GetRoomByProperty(propertyId);
            }
            else
            {
                //mock data
                response.Rooms = new List<Resources.Entities.Room>
                {
                    new Room
                    {
                        Id = 1,
                        Number = "Room AB",
                        RoomType = new RoomType
                        {
                            Id = 1,
                            Name = "King-Smoking"
                        }
                    },

                    new Room
                    {
                        Id = 2,
                        Number = "Room AC",
                        RoomType = new RoomType
                        {
                            Id = 2,
                            Name = "King-NonSmoking"
                        }
                    },

                    new Room
                    {
                        Id = 3,
                        Number = "Room AD",
                        RoomType = new RoomType
                        {
                            Id = 3,
                            Name = "Queen-Smoking"
                        }
                    },

                    new Room
                    {
                        Id = 4,
                        Number = "Room AE",
                        RoomType = new RoomType
                        {
                            Id = 1,
                            Name = "King-Smoking"
                        }
                    }
                };
            }
            return response;
        }
        
        [HttpGet, ActionName("GetRoomById")]
        public GetRoomResponseDto GetRoomById(int propertyId, int roomId)
        {
            if (propertyId <= 0) throw new PmsException("Property id is not valid.");

            var response = new GetRoomResponseDto();
            if (roomId <= 0)
            {
                return response;
            }
            var roomResponseDto = GetRoomByProperty(propertyId);
            if (roomResponseDto == null || roomResponseDto.Rooms == null || roomResponseDto.Rooms.Count <= 0) return response;

            response.Rooms = roomResponseDto.Rooms.Where(x => x.Id.Equals(roomId)).ToList();
            return response;
        }

        [HttpGet, ActionName("GetRoomByStatus")]
        public GetRoomResponseDto GetRoomByStatus(int propertyId, int statusId)
        {
            if (propertyId <= 0) throw new PmsException("Property id is not valid.");

            var response = new GetRoomResponseDto();
            if (statusId <= 0)
            {
                return response;
            }
            var roomResponseDto = GetRoomByProperty(propertyId);
            if (roomResponseDto == null || roomResponseDto.Rooms == null || roomResponseDto.Rooms.Count <= 0) return response;

            response.Rooms = roomResponseDto.Rooms.Where(x => x.RoomStatus.Id.Equals(statusId)).ToList();
            return response;
        }

        [HttpGet, ActionName("GetRoomByRoomType")]
        public GetRoomResponseDto GetRoomByRoomType(int propertyId, int typeId)
        {
            if (propertyId <= 0) throw new PmsException("Property id is not valid.");

            var response = new GetRoomResponseDto();
            if (typeId <= 0)
            {
                return response;
            }
            var roomResponseDto = GetRoomByProperty(propertyId);
            if (roomResponseDto == null || roomResponseDto.Rooms == null || roomResponseDto.Rooms.Count <= 0) return response;

            response.Rooms = roomResponseDto.Rooms.Where(x => x.RoomStatus.Id.Equals(typeId)).ToList();
            return response;
        }
        
        [HttpGet, ActionName("GetRoomByRoomNumber")]
        public GetRoomResponseDto GetRoomByRoomNumber(int propertyId, string roomNumber)
        {
            if (propertyId <= 0) throw new PmsException("Property id is not valid.");

            var response = new GetRoomResponseDto();
            if (string.IsNullOrWhiteSpace(roomNumber))
            {
                return response;
            }
            var roomResponseDto = GetRoomByProperty(propertyId);
            if (roomResponseDto == null || roomResponseDto.Rooms == null || roomResponseDto.Rooms.Count <= 0) return response;

            response.Rooms = roomResponseDto.Rooms.Where(x => x.Number.Equals(roomNumber)).ToList();
            return response;
        }


        [HttpPost, ActionName("GetRoomByDate")]
        public GetRoomResponseDto GetRoomByDate([FromBody] GetRoomByDateRequestDto request)
        {
            if (request == null || request.PropertyId <= 0 || request.CheckinDate == null || request.CheckoutDate == null) throw new PmsException("Room details can not be fetch.");
            var response = new GetRoomResponseDto();

            response.Rooms = _iPmsLogic.GetRoomByDate(request);

            return response;
        }
    }
}
