﻿using PMS.Resources.Common.Constants;
using PMS.Resources.Common.Helper;
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
using PmsEntity = PMS.Resources.Entities;

namespace PMS.Api.Controllers
{
    public partial class RoomController : ApiController, IRestController
    {
        private void MapHttpRoutesForRateType(HttpConfiguration config)
        {
            config.Routes.MapHttpRoute(
            "AddRateType",
            "api/v1/Room/AddRateType",
            new { controller = "Room", action = "AddRateType" }
            );

            config.Routes.MapHttpRoute(
             "UpdateRateType",
             "api/v1/Room/UpdateRateType",
             new { controller = "Room", action = "UpdateRateType" }
             );

            config.Routes.MapHttpRoute(
             "DeleteRateType",
             "api/v1/Room/DeleteRateType/{typeId}",
             new { controller = "Room", action = "DeleteRateType" },
             constraints: new { typeId = RegExConstants.NumericRegEx }
             );

            config.Routes.MapHttpRoute(
              "GetRateTypeByProperty",
              "api/v1/Room/GetRateTypeByProperty/{propertyId}",
              new { controller = "Room", action = "GetRateTypeByProperty" },
              constraints: new { propertyId = RegExConstants.NumericRegEx }
              );

            config.Routes.MapHttpRoute(
              "GetRoomRateByProperty",
              "api/v1/Room/GetRoomRateByProperty/{propertyId}",
              new { controller = "Room", action = "GetRoomRateByProperty" },
              constraints: new { propertyId = RegExConstants.NumericRegEx }
              );

            config.Routes.MapHttpRoute(
              "GetRateTypeById",
              "api/v1/Room/{propertyId}/GetRateTypeById/{typeId}",
              new { controller = "Room", action = "GetRateTypeById" },
              constraints: new { propertyId = RegExConstants.NumericRegEx, typeId = RegExConstants.NumericRegEx }
              );

            config.Routes.MapHttpRoute(
            "AddRoomRate",
            "api/v1/Room/AddRoomRate",
            new { controller = "Room", action = "AddRoomRate" }
            );

            config.Routes.MapHttpRoute(
             "UpdateRoomRate",
             "api/v1/Room/UpdateRoomRate",
             new { controller = "Room", action = "UpdateRoomRate" }
             );

            config.Routes.MapHttpRoute(
             "DeleteRoomRate",
             "api/v1/Room/DeleteRoomRate/{rateId}",
             new { controller = "Room", action = "DeleteRoomRate" },
             constraints: new { rateId = RegExConstants.NumericRegEx }
             );
        }

        [HttpPost, ActionName("AddRateType")]
        public PmsResponseDto AddRateType([FromBody] AddRateTypeRequestDto request)
        {
            if (request == null || request.RateType == null) throw new PmsException("Rate type can not be added.");

            var response = new PmsResponseDto();
            var Id = _iPmsLogic.AddRateType(request.RateType);
            if (Id > 0)
            {
                response.ResponseStatus = PmsApiStatus.Success.ToString();
                response.StatusDescription = "Record(s) saved successfully.";
                response.ResponseObject = Id;
            }
            else
            {
                response.ResponseStatus = PmsApiStatus.Failure.ToString();
                response.StatusDescription = "Operation failed.Please contact administrator.";
            }
            return response;
        }

        [HttpPut, ActionName("UpdateRateType")]
        public PmsResponseDto UpdateRateType([FromBody] UpdateRateTypeRequestDto request)
        {
            if (request == null || request.RateType == null || request.RateType.Id <= 0) throw new PmsException("Rate type can not be updated.");

            var response = new PmsResponseDto();
            if (_iPmsLogic.UpdateRateType(request.RateType))
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

        [HttpDelete, ActionName("DeleteRateType")]
        public PmsResponseDto DeleteRateType(int typeId)
        {
            if (typeId <= 0) throw new PmsException("RateType id is not valid. Hence RateType can not be deleted.");

            var response = new PmsResponseDto();
            if (_iPmsLogic.DeleteRateType(typeId))
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

        [HttpGet, ActionName("GetRoomRateByProperty")]
        public GetRoomRateResponseDto GetRoomRateByProperty(int propertyId)
        {
            if (propertyId <= 0) throw new PmsException("Property id is not valid.");

            var response = new GetRoomRateResponseDto();
            if (!AppConfigReaderHelper.AppConfigToBool(AppSettingKeys.MockEnabled))
            {
                response.RoomRate = _iPmsLogic.GetRoomRateByProperty(propertyId);
            }
            return response;
        }

        [HttpGet, ActionName("GetRateTypeByProperty")]
        public GetRateTypeResponseDto GetRateTypeByProperty(int propertyId)
        {
            if (propertyId <= 0) throw new PmsException("Property id is not valid.");

            var response = new GetRateTypeResponseDto();
            if (!AppConfigReaderHelper.AppConfigToBool(AppSettingKeys.MockEnabled))
            {
                response.RateTypes = _iPmsLogic.GetRateTypeByProperty(propertyId);
            }
            else
            {
                //mock data
                response.RateTypes = new List<Resources.Entities.RateType>
                {
                    new PmsEntity.RateType
                    {
                        Id = 1,
                        Name = "Apartment Standard Test"
                    },
                    new PmsEntity.RateType
                    {
                        Id = 2,
                        Name = "Apartment Standard"
                    },
                    new PmsEntity.RateType
                    {
                        Id = 3,
                        Name = "Queen Standard"
                    },
                    new PmsEntity.RateType
                    {
                        Id = 4,
                        Name = "Holiday Standard"
                    },
                    new PmsEntity.RateType
                    {
                        Id = 5,
                        Name = "My Weekend Standard"
                    }
                };
            }
            return response;
        }

        [HttpGet, ActionName("GetRateTypeById")]
        public GetRateTypeResponseDto GetRateTypeById(int propertyId, int typeId)
        {
            if (propertyId <= 0) throw new PmsException("Property id is not valid.");

            var response = new GetRateTypeResponseDto();
            if (typeId <= 0)
            {
                return response;
            }
            var rateTypeResponseDto = GetRateTypeByProperty(propertyId);
            if (rateTypeResponseDto == null || rateTypeResponseDto.RateTypes == null || rateTypeResponseDto.RateTypes.Count <= 0) return response;

            response.RateTypes = rateTypeResponseDto.RateTypes.Where(x => x.Id.Equals(typeId)).ToList();
            return response;
        }

        [HttpPost, ActionName("AddRoomRate")]
        public PmsResponseDto AddRoomRate([FromBody] RoomRateRequestDto request)
        {
            if (request == null || request.Rates == null || request.Rates.Count <= 0) throw new PmsException("Invalid Room Rate add request.");

            var response = new PmsResponseDto();
            if (_iPmsLogic.AddRoomRate(request.Rates))
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

        [HttpPut, ActionName("UpdateRoomRate")]
        public PmsResponseDto UpdateRoomRate([FromBody] RoomRateRequestDto request)
        {
            if (request == null || request.Rates == null || request.Rates.Count <= 0) throw new PmsException("Room Rate can not be updated.");

            var response = new PmsResponseDto();
            if (_iPmsLogic.UpdateRoomRate(request.Rates))
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

        [HttpDelete, ActionName("DeleteRoomRate")]
        public PmsResponseDto DeleteRoomRate(int rateId)
        {
            if (rateId <= 0) throw new PmsException("Room Rate id is not valid. Hence Room Rate can not be deleted.");

            var response = new PmsResponseDto();
            if (_iPmsLogic.DeleteRoomRate(rateId))
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
    }
}