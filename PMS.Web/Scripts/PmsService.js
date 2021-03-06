﻿(function (win) {
    function PmsService() {

        this.Config = {
            BaseUrl: window.apiBaseUrl
        };

        this.Handlers = {
            OnGetRoomTypeByPropertySuccess: null,
            OnGetRoomTypeByPropertyFailure: null,
            OnGetRateTypeByPropertySuccess: null,
            OnGetRateTypeByPropertyFailure: null,
            OnGetRoomByPropertySuccess: null,
            OnGetRoomByPropertyFailure: null,
            OnAddBookingSuccess: null,
            OnAddBookingFailure: null,
            OnImageUploadSuccess: null,
            OnImageUploadFailure: null,
            OnGetRoomByDateSuccess: null,
            OnGetRoomByDateFailure: null,
            OnGetGuestHistoryByIdSuccess: null,
            OnGetGuestHistoryByIdFailure: null,
            OnGetCountryFailure: null,
            OnGetCountrySuccess: null,
            OnGetStateByCountryFailure: null,
            OnGetStateByCountrySuccess: null,
            OnGetAllGuestFailure: null,
            OnGetAllGuestSuccess: null,
            OnGetCityByStateFailure: null,
            OnGetCityByStateSuccess: null,
            OnGetPaymentChargesFailure: null,
            OnGetPaymentChargesSuccess: null,
            OnAddInvoiceSuccess: null,
            OnAddInvoiceFailure: null,
            OnGetInvoiceByIdSuccess: null,
            OnGetInvoiceByIdFailure: null,
            OnGetBookingByIdSuccess: null,
            OnGetBookingByIdFailure: null,
            OnGetAllPropertySuccess: null,
            OnGetAllPropertyFailure: null,            
            OnGetPropertyForAccessSuccess: null,
            OnGetPropertyForAccessFailure: null,
            OnAddPropertySuccess: null,
            OnAddPropertyFailure: null,
            OnDeletePropertySuccess: null,
            OnDeletePropertyFailure: null,
            OnUpdatePropertySuccess: null,
            OnUpdatePropertyFailure: null,
            OnDeleteRoomTypeSuccess: null,
            OnDeleteRoomTypeFailure: null,
            OnUpdateRoomTypeSuccess: null,
            OnUpdateRoomTypeFailure: null,
            OnAddRoomTypeSuccess: null,
            OnAddRoomTypeFailure: null,
            OnGetFloorsByPropertySuccess: null,
            OnGetFloorsByPropertyFailure: null,
            OnDeleteFloorSuccess: null,
            OnDeleteFloorFailure: null,
            OnAddFloorSuccess: null,
            OnAddFloorFailure: null,
            OnUpdateFloorSuccess: null,
            OnUpdateFloorFailure: null,
            OnGetPaymentTypeByPropertySuccess: null,
            OnGetPaymentTypeByPropertyFailure: null,
            OnDeletePaymentTypeSuccess: null,
            OnDeletePaymentTypeFailure: null,
            OnAddPaymentTypeSuccess: null,
            OnAddPaymentTypeFailure: null,
            OnUpdatePaymentTypeSuccess: null,
            OnUpdatePaymentTypeFailure: null,
            OnGetExtraChargeByPropertySuccess: null,
            OnGetExtraChargeByPropertyFailure: null,
            OnDeleteExtraChargeSuccess: null,
            OnDeleteExtraChargeFailure: null,
            OnAddExtraChargeSuccess: null,
            OnAddExtraChargeFailure: null,
            OnUpdateExtraChargeSuccess: null,
            OnUpdateExtraChargeFailure: null,
            OnGetTaxByPropertySuccess: null,
            OnGetTaxByPropertyFailure: null,
            OnDeleteTaxSuccess: null,
            OnDeleteTaxFailure: null,
            OnAddTaxSuccess: null,
            OnAddTaxFailure: null,
            OnUpdateTaxSuccess: null,
            OnUpdateTaxFailure: null,
            OnDeleteRateTypeSuccess: null,
            OnDeleteRateTypeFailure: null,
            OnAddRateTypeSuccess: null,
            OnAddRateTypeFailure: null,
            OnUpdateRateTypeSuccess: null,
            OnUpdateRateTypeFailure: null,            
            OnDeleteRoomSuccess: null,
            OnDeleteRoomFailure: null,
            OnAddRoomSuccess: null,
            OnAddRoomFailure: null,
            OnUpdateRoomSuccess: null,
            OnUpdateRoomFailure: null,
            OnGetRoomByPropertySuccess: null,
            OnGetRoomByPropertyFailure: null,
            OnGetRoomRateByPropertySuccess: null,
            OnGetRoomRateByPropertyFailure: null,
            OnAddRoomRateSuccess: null,
            OnAddRoomRateFailure: null,
            OnUpdateRoomRateSuccess: null,
            OnUpdateRoomRateFailure: null,
            OnDeleteRoomRateSuccess: null,
            OnDeleteRoomRateFailure: null,
            OnUpdateRoomStatusSuccess: null,
            OnUpdateRoomStatusFailure: null,
            OnGetBookingTransactionSuccess: null,
            OnGetBookingTransactionFailure: null,
            OnDeleteBookingSuccess: null,
            OnDeleteBookingFailure: null,
            OnUpdateStatusSuccess: null,
            OnUpdateStatusFailure: null,
            OnGetExpenseCategoryByPropertySuccess: null,
            OnGetExpenseCategoryByPropertyFailure: null,
            OnDeleteExpenseCategorySuccess: null,
            OnDeleteExpenseCategoryFailure: null,
            OnAddExpenseCategorySuccess: null,
            OnAddExpenseCategoryFailure: null,
            OnUpdateExpenseCategorySuccess: null,
            OnUpdateExpenseCategoryFailure: null,
            OnGetExpenseBySearchSuccess: null,
            OnGetExpenseBySearchFailure: null,
            OnDeleteExpenseSuccess: null,
            OnDeleteExpenseFailure: null,
            OnAddExpenseSuccess: null,
            OnAddExpenseFailure: null,
            OnUpdateExpenseSuccess: null,
            OnUpdateExpenseFailure: null,
            OnGetShiftReportSuccess:null,
            OnGetShiftReportFailure:null,
            OnGetConsolidatedShiftReportSuccess:null,
            OnGetConsolidatedShiftReportFailure:null,
            OnGetManagerDataSuccess: null,
            OnGetManagerDataFailure: null,
            OnDeleteUserSuccess: null,
            OnDeleteUserFailure: null,
            OnAddUserSuccess: null,
            OnAddUserFailure: null,
            OnUpdateUserSuccess: null,
            OnUpdateUserFailure: null,
            OnGetAllUserSuccess: null,
            OnGetAllUserFailure: null,
            OnGetPropertyByUserIdSuccess: null,
            OnGetPropertyByUserIdFailure: null,
            OnGetAllFunctionalitySuccess: null,
            OnGetAllFunctionalityFailure: null,
            OnGetFunctionalityByUserIdSuccess: null,
            OnGetFunctionalityByUserIdFailure: null,
            OnInsertUserAccessSuccess: null,
            OnInsertUserAccessFailure: null,
            OnGetConsolidatedManagerDataPreviousMonthSuccess:null,
            OnGetConsolidatedManagerDataPreviousMonthFailure: null,
            OnGetConsolidatedManagerDataPreviousYearSuccess:null,
            OnGetConsolidatedManagerDataPreviousYearFailure: null,
            OnGetGuestSummarySucess: null,
            OnGetGuestSummaryFailure: null,
            OnDeleteGuestSuccess: null,
            OnDeleteGuestFailure: null,
            OnAddGuestSuccess: null,
            OnAddGuestFailure: null,
            OnUpdateGuestSuccess: null,
            OnUpdateGuestFailure: null,
            OnGetGuestSuccess: null,
            OnGetGuestFailure: null,
            OnCancelReservationSuccess: null,
            OnCancelReservationFailure: null,
            OnUpdatePasswordSuccess: null,
            OnUpdatePasswordFailure: null
        };

        this.UpdateStatus = function (args) {
            makeAjaxRequestPut(args, "UpdateStatus", this, "api/v1/Booking/UpdateStatus");
        };

        this.DeleteBooking = function (args) {
            makeAjaxRequestDelete(args, "DeleteBooking", this, "api/v1/Booking/DeleteBooking/" + args.bookingId);
        };

        this.GetBookingTransaction = function (args) {
            makeAjaxRequestPost(args, "GetBookingTransaction", this, "api/v1/Booking/GetBookingTransaction");
        };

        this.UpdateRoomStatus = function (args) {
            makeAjaxRequestPut(args, "UpdateRoomStatus", this, "api/v1/Room/UpdateRoomStatus");
        };

        this.UpdateRoomRate = function (args) {
            makeAjaxRequestPut(args, "UpdateRoomRate", this, "api/v1/Room/UpdateRoomRate");
        };

        this.AddRoomRate = function (args) {
            makeAjaxRequestPost(args, "AddRoomRate", this, "api/v1/Room/AddRoomRate");
        };

        this.DeleteRoomRate = function (args) {
            makeAjaxRequestDelete(args, "DeleteRoomRate", this, "api/v1/Room/DeleteRoomRate/" + args.rateId);
        };

        this.UpdateRoom = function (args) {
            makeAjaxRequestPut(args, "UpdateRoom", this, "api/v1/Room/UpdateRoom");
        };

        this.AddRoom = function (args) {
            makeAjaxRequestPost(args, "AddRoom", this, "api/v1/Room/AddRoom");
        };

        this.DeleteRoom = function (args) {
            makeAjaxRequestDelete(args, "DeleteRoom", this, "api/v1/Room/DeleteRoom/" + args.roomId);
        };

        this.GetRoomByProperty = function (args) {
            makeAjaxRequestGet(args, "GetRoomByProperty", this, "api/v1/Room/GetRoomByProperty/" + args.propertyId);
        };

        this.GetRoomRateByProperty = function (args) {
            makeAjaxRequestGet(args, "GetRoomRateByProperty", this, "api/v1/Room/GetRoomRateByProperty/" + args.propertyId);
        };

        this.UpdateRateType = function (args) {
            makeAjaxRequestPut(args, "UpdateRateType", this, "api/v1/Room/UpdateRateType");
        };

        this.AddRateType = function (args) {
            makeAjaxRequestPost(args, "AddRateType", this, "api/v1/Room/AddRateType");
        };

        this.DeleteRateType = function (args) {
            makeAjaxRequestDelete(args, "DeleteRateType", this, "api/v1/Room/DeleteRateType/" + args.typeId);
        };

        this.UpdateTax = function (args) {
            makeAjaxRequestPut(args, "UpdateTax", this, "api/v1/Tax/UpdateTax");
        };

        this.AddTax = function (args) {
            makeAjaxRequestPost(args, "AddTax", this, "api/v1/Tax/AddTax");
        };

        this.DeleteTax = function (args) {
            makeAjaxRequestDelete(args, "DeleteTax", this, "api/v1/Tax/DeleteTax/" + args.taxId);
        };

        this.GetTaxByProperty = function (args) {
            makeAjaxRequestGet(args, "GetTaxByProperty", this, "api/v1/Tax/GetTaxByProperty/" + args.propertyId);
        };

        this.UpdateExtraCharge = function (args) {
            makeAjaxRequestPut(args, "UpdateExtraCharge", this, "api/v1/ExtraCharge/UpdateExtraCharge");
        };

        this.AddExtraCharge = function (args) {
            makeAjaxRequestPost(args, "AddExtraCharge", this, "api/v1/ExtraCharge/AddExtraCharge");
        };

        this.DeleteExtraCharge = function (args) {
            makeAjaxRequestDelete(args, "DeleteExtraCharge", this, "api/v1/ExtraCharge/DeleteExtraCharge/" + args.id);
        };

        this.GetExtraChargeByProperty = function (args) {
            makeAjaxRequestGet(args, "GetExtraChargeByProperty", this, "api/v1/ExtraCharge/GetExtraChargeByProperty/" + args.propertyId);
        };

        this.UpdatePaymentType = function (args) {
            makeAjaxRequestPut(args, "UpdatePaymentType", this, "api/v1/Payment/UpdatePaymentType");
        };

        this.AddPaymentType = function (args) {
            makeAjaxRequestPost(args, "AddPaymentType", this, "api/v1/Payment/AddPaymentType");
        };

        this.DeletePaymentType = function (args) {
            makeAjaxRequestDelete(args, "DeletePaymentType", this, "api/v1/Payment/DeletePaymentType/" + args.typeId);
        };

        this.GetPaymentTypeByProperty = function (args) {
            makeAjaxRequestGet(args, "GetPaymentTypeByProperty", this, "api/v1/Payment/GetPaymentTypeByProperty/" + args.propertyId);
        };

        this.UpdateFloor = function (args) {
            makeAjaxRequestPut(args, "UpdateFloor", this, "api/v1/PropertyFloor/UpdateFloor");
        };

        this.AddFloor = function (args) {
            makeAjaxRequestPost(args, "AddFloor", this, "api/v1/PropertyFloor/AddFloor");
        };

        this.DeleteFloor = function (args) {
            makeAjaxRequestDelete(args, "DeleteFloor", this, "api/v1/PropertyFloor/DeleteFloor/" + args.floorId);
        };

        this.GetFloorsByProperty = function (args) {
            makeAjaxRequestGet(args, "GetFloorsByProperty", this, "api/v1/PropertyFloor/GetFloorsByProperty/" + args.propertyId);
        };

        this.UpdateProperty = function (args) {
            makeAjaxRequestPut(args, "UpdateProperty", this, "api/v1/Property/UpdateProperty");
        };

        this.DeleteProperty = function (args) {
            makeAjaxRequestDelete(args, "DeleteProperty", this, "api/v1/Property/DeleteProperty/" + args.propertyId);
        };

        this.UpdateRoomType = function (args) {
            makeAjaxRequestPut(args, "UpdateRoomType", this, "api/v1/Room/UpdateRoomType");
        };

        this.DeleteRoomType = function (args) {
            makeAjaxRequestDelete(args, "DeleteRoomType", this, "api/v1/Room/DeleteRoomType/" + args.roomTypeId);
        };

        this.AddRoomType = function (args) {
            makeAjaxRequestPost(args, "AddRoomType", this, "api/v1/Room/AddRoomType");
        };

        this.AddProperty = function (args) {
            makeAjaxRequestPost(args, "AddProperty", this, "api/v1/Property/AddProperty");
        };

        this.GetAllProperty = function (args) {
            makeAjaxRequestGet(args, "GetAllProperty", this, "api/v1/Property/GetAllProperty/" + args.userId);
        };
        this.GetPropertyForAccess = function (args) {
            makeAjaxRequestGet(args, "GetPropertyForAccess", this, "api/v1/Property/GetPropertyForAccess");
        };
        
        this.GetBookingById = function (args) {
            makeAjaxRequestGet(args, "GetBookingById", this, "api/v1/Booking/GetBookingById/" + args.bookingId);
        };

        this.GetInvoiceById = function (args) {
            makeAjaxRequestPost(args, "GetInvoiceById", this, "api/v1/Invoice/GetInvoiceById");
        };

        this.GetPaymentCharges = function (args) {
            makeAjaxRequestPost(args, "GetPaymentCharges", this, "api/v1/Invoice/GetPaymentCharges");
        };

        this.GetAllGuest = function (args) {
            makeAjaxRequestGet(args, "GetAllGuest", this, "api/v1/Guest/GetAllGuest");
        };

        this.GetStateByCountry = function (args) {
            makeAjaxRequestGet(args, "GetStateByCountry", this, "api/v1/Booking/GetStateByCountry?id=" + args.Id);
        };

        this.GetCityByState = function (args) {
            makeAjaxRequestGet(args, "GetCityByState", this, "api/v1/Booking/GetCityByState?id=" + args.Id);
        };

        this.GetCountry = function (args) {
            makeAjaxRequestGet(args, "GetCountry", this, "api/v1/Booking/GetCountry");
        };

        this.GetGuestHistoryById = function (args) {
            makeAjaxRequestGet(args, "GetGuestHistoryById", this, "api/v1/Guest/GetGuestHistoryById/" + args.guestId);
        };

        this.GetRoomByDate = function (args) {
            makeAjaxRequestPost(args, "GetRoomByDate", this, "api/v1/Room/GetRoomByDate");
        };

        this.ImageUpload = function (args) {
            makeAjaxRequestForImage(args, "ImageUpload", this, "api/v1/Image/ImageUpload");
        };

        this.AddBooking = function (args) {
            makeAjaxRequestPost(args, "AddBooking", this, "api/v1/Booking/AddBooking");
        };

        this.AddInvoice = function (args) {
            makeAjaxRequestPost(args, "AddInvoice", this, "api/v1/Invoice/AddInvoice");
        };

        this.GetRoomTypeByProperty = function (args) {
            makeAjaxRequestGet(args, "GetRoomTypeByProperty", this, "api/v1/Room/GetRoomTypeByProperty/" + args.propertyId);
        };

        this.GetRateTypeByProperty = function (args) {
            makeAjaxRequestGet(args, "GetRateTypeByProperty", this, "api/v1/Room/GetRateTypeByProperty/" + args.propertyId);
        };

        this.GetExpenseCategoryByProperty = function (args) {
            makeAjaxRequestGet(args, "GetExpenseCategoryByProperty", this, "api/v1/ExpenseCategory/GetExpenseCategoryByProperty/" + args.propertyId);
        };

        this.UpdateExpenseCategory = function (args) {
            makeAjaxRequestPut(args, "UpdateExpenseCategory", this, "api/v1/ExpenseCategory/UpdateExpenseCategory");
        };

        this.AddExpenseCategory = function (args) {
            makeAjaxRequestPost(args, "AddExpenseCategory", this, "api/v1/ExpenseCategory/AddExpenseCategory");
        };

        this.DeleteExpenseCategory = function (args) {
            makeAjaxRequestDelete(args, "DeleteExpenseCategory", this, "api/v1/ExpenseCategory/DeleteExpenseCategory/" + args.typeId);
        };

        this.GetExpenseBySearch = function (args) {
            makeAjaxRequestPost(args, "GetExpenseBySearch", this, "api/v1/Expense/GetExpenseBySearch");
        };

        this.UpdateExpense = function (args) {
            makeAjaxRequestPut(args, "UpdateExpense", this, "api/v1/Expense/UpdateExpense");
        };

        this.AddExpense = function (args) {
            makeAjaxRequestPost(args, "AddExpense", this, "api/v1/Expense/AddExpense");
        };

        this.DeleteExpense = function (args) {
            makeAjaxRequestDelete(args, "DeleteExpense", this, "api/v1/Expense/DeleteExpense/" + args.typeId);
        };

        this.GetShiftReport = function (args) {
            makeAjaxRequestPost(args, "GetShiftReport", this, "api/v1/Reports/GetShiftReport");
        };

        this.GetConsolidatedShiftReport = function (args) {
            makeAjaxRequestPost(args, "GetConsolidatedShiftReport", this, "api/v1/Reports/GetConsolidatedShiftReport");
        };

        this.GetManagerReport = function (args) {
            makeAjaxRequestPost(args, "GetManagerData", this, "api/v1/Reports/GetManagerData");
        };
        this.GetConsolidatedManagerDataPreviousMonth = function (args) {
            makeAjaxRequestPost(args, "GetConsolidatedManagerDataPreviousMonth", this, "api/v1/Reports/GetConsolidatedManagerDataPreviousMonth");
        };
        this.GetConsolidatedManagerDataPreviousYear = function (args) {
            makeAjaxRequestPost(args, "GetConsolidatedManagerDataPreviousYear", this, "api/v1/Reports/GetConsolidatedManagerDataPreviousYear");
        };

        this.UpdateUser = function (args) {
            makeAjaxRequestPut(args, "UpdateUser", this, "api/v1/User/UpdateUser");
        };

        this.AddUser = function (args) {
            makeAjaxRequestPost(args, "AddUser", this, "api/v1/User/AddUser");
        };

        this.DeleteUser = function (args) {
            makeAjaxRequestDelete(args, "DeleteUser", this, "api/v1/User/DeleteUser/" + args.userId);
        };       

        this.GetAllUser = function (args) {
            makeAjaxRequestGet(args, "GetAllUser", this, "api/v1/User/GetAllUser");
        };
        this.GetPropertyByUserId = function (args) {
            makeAjaxRequestGet(args, "GetPropertyByUserId", this, "api/v1/Property/GetPropertyByUserId/" + args.userId);
        };
        this.GetAllFunctionality = function (args) {
            makeAjaxRequestGet(args, "GetAllFunctionality", this, "api/v1/Functionality/GetAllFunctionality");
        };
        this.GetFunctionalityByUserId = function (args) {
            makeAjaxRequestGet(args, "GetFunctionalityByUserId", this, "api/v1/Functionality/GetFunctionalityByUserId/" + args.userId);
        };
        this.InsertUserAccess = function (args) {
            makeAjaxRequestPost(args, "InsertUserAccess", this, "api/v1/User/InsertUserAccess");
        };        
         this.GetGuestSummary = function (args) {
            makeAjaxRequestPost(args, "GetGuestSummary", this, "api/v1/Booking/GetGuestSummary");
         };

        this.UpdateGuest = function (args) {
            makeAjaxRequestPut(args, "UpdateGuest", this, "api/v1/Guest/UpdateGuest");
        };

        this.AddGuest = function (args) {
            makeAjaxRequestPost(args, "AddGuest", this, "api/v1/Guest/AddGuest");
        };

        this.DeleteGuest = function (args) {
            makeAjaxRequestDelete(args, "DeleteGuest", this, "api/v1/Guest/DeleteGuest/" + args.guestId);
        };       

        this.GetGuest = function (args) {
            makeAjaxRequestGet(args, "GetGuest", this, "api/v1/Guest/GetGuest");
        };

        this.CancelReservation = function (args) {
            makeAjaxRequestGet(args, "CancelReservation", this, "api/v1/Booking/CancelReservation/"+args.id);
        };
        this.UpdatePassword = function (args) {
            makeAjaxRequestPost(args, "UpdatePassword", this, "api/v1/User/UpdatePassword");
        };

        function makeAjaxRequestDelete(args, operationName, e, uri) {
            var url = e.Config.BaseUrl + uri;
            var successCallback = makeSuccessHandler(operationName, e);
            var failureCallback = makeFailureHandler(operationName, e);
            var completeCallback = makeCompleteHandler(operationName, e);

            if (win.PmsAjaxQueue != null) {
                win.PmsAjaxQueue.AddToQueue(url, successCallback, failureCallback, completeCallback, 'DELETE');
                return;
            }

            if (e.AjaxRequestInProgress) {
                alert("An Ajax request is already in progress cannot start another one. Please wait and try again later");
                return;
            }

            $.ajax({
                url: url,
                success: successCallback,
                type: "DELETE",
                contentType: "application/json",
                error: failureCallback,
                complete: completeCallback
            });
        }

        function makeAjaxRequestGet(args, operationName, e, uri) {
            var url = e.Config.BaseUrl + uri;
            var successCallback = makeSuccessHandler(operationName, e);
            var failureCallback = makeFailureHandler(operationName, e);
            var completeCallback = makeCompleteHandler(operationName, e);

            if (win.PmsAjaxQueue != null) {
                win.PmsAjaxQueue.AddToQueue(url, successCallback, failureCallback, completeCallback, 'GET');
                return;
            }

            if (e.AjaxRequestInProgress) {
                alert("An Ajax request is already in progress cannot start another one. Please wait and try again later");
                return;
            }

            $.ajax({
                url: url,
                success: successCallback,
                type: "GET",
                contentType: "application/json",
                error: failureCallback,
                complete: completeCallback
            });
        }

        function makeAjaxRequestForImage(args, operationName, e, uri) {
            var url = e.Config.BaseUrl + uri;
            var successCallback = makeSuccessHandler(operationName, e);
            var failureCallback = makeFailureHandler(operationName, e);
            var completeCallback = makeCompleteHandler(operationName, e);

            //if (win.PmsAjaxQueue != null) {
            //    win.PmsAjaxQueue.AddToQueue(url, successCallback, failureCallback, completeCallback, args);
            //    return;
            //}

            //if (e.AjaxRequestInProgress) {
            //    alert("An Ajax request is already in progress cannot start another one. Please wait and try again later");
            //    return;
            //}

            $.ajax({
                url: url,
                success: successCallback,
                type: "POST",
                contentType: false,
                processData: false,
                data: args,
                error: failureCallback,
                complete: completeCallback
            });
        }

        function makeAjaxRequestPost(args, operationName, e, uri) {
            var url = e.Config.BaseUrl + uri;
            var successCallback = makeSuccessHandler(operationName, e);
            var failureCallback = makeFailureHandler(operationName, e);
            var completeCallback = makeCompleteHandler(operationName, e);

            if (win.PmsAjaxQueue != null) {
                win.PmsAjaxQueue.AddToQueue(url, successCallback, failureCallback, completeCallback, 'POST', args);
                return;
            }

            if (e.AjaxRequestInProgress) {
                alert("An Ajax request is already in progress cannot start another one. Please wait and try again later");
                return;
            }

            $.ajax({
                url: url,
                success: successCallback,
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(args),
                error: failureCallback,
                complete: completeCallback
            });
        }

        function makeAjaxRequestPut(args, operationName, e, uri) {
            var url = e.Config.BaseUrl + uri;
            var successCallback = makeSuccessHandler(operationName, e);
            var failureCallback = makeFailureHandler(operationName, e);
            var completeCallback = makeCompleteHandler(operationName, e);

            if (win.PmsAjaxQueue != null) {
                win.PmsAjaxQueue.AddToQueue(url, successCallback, failureCallback, completeCallback, 'PUT', args);
                return;
            }

            if (e.AjaxRequestInProgress) {
                alert("An Ajax request is already in progress cannot start another one. Please wait and try again later");
                return;
            }

            $.ajax({
                url: url,
                success: successCallback,
                type: "PUT",
                contentType: "application/json",
                data: JSON.stringify(args),
                error: failureCallback,
                complete: completeCallback
            });
        }

        function makeSuccessHandler(handlerName, e) {
            return function (data) {
                invokeHandler(e.Handlers["On" + handlerName + "Success"], data);
            };
        }

        function makeFailureHandler(handlerName, e) {
            return function (jqXhr, textStatus, errorThrown) {
                invokeHandler(e.Handlers["On" + handlerName + "Failure"], errorThrown, jqXhr.status);
            };
        }

        function makeCompleteHandler(handlerName, e) {
            return function (jqXhr) {
                invokeHandler(e.Handlers["On" + handlerName + "Complete"], jqXhr.status);
            };
        }

        function invokeHandler(handler, input, jqXhrStatus) {
            if (typeof handler === 'function') {
                handler(input, jqXhrStatus);
            }
        }
    }

win.PmsAjaxQueue = win.PmsAjaxQueue ? new win.PmsAjaxQueue() : null;
win.PmsService = PmsService;
}(window));