﻿(function (win) {
    var pmsService = new window.PmsService();
    var pmsSession = window.PmsSession;
    var args = {};    
    var guestCheckinManager = {
        
        Initialize: function () {                       
            ajaxHandlers();
            getRoomTypes();
            getRoomRateTypes();
            getRooms();
        },

        BindRoomDdl: function () {
            var ddlRoom = $('#roomddl');
            var ddlRateType = $('#rateTypeDdl');
            var roomData = pmsSession.GetItem("roomdata");
            if (!ddlRoom || !ddlRateType || !roomData) return;

            var rooms = $.parseJSON(roomData);
            if (!rooms || rooms.length <= 0) return;

            ddlRoom.empty();
            ddlRoom.append(new Option("Select Room", "-1"));
            var rateTypeId = parseInt(ddlRateType.val());
            if (rateTypeId > -1) {
                for (var i = 0; i < rooms.length; i++) {
                    if (rooms[i].RateType.Id !== rateTypeId) continue;

                    ddlRoom.append(new Option(rooms[i].Number, rooms[i].Id));
                }
            }
        },

        BindRoomTypeDdl: function () {
            var ddlRoomType = $('#roomTypeDdl');
            var roomTypeData = pmsSession.GetItem("roomtypedata");
            if (!ddlRoomType || !roomTypeData) return;

            var roomTypes = $.parseJSON(roomTypeData);
            if (!roomTypes || roomTypes.length <= 0) return;

            ddlRoomType.empty();
            ddlRoomType.append(new Option("Select Type", "-1"));
            for (var i = 0; i < roomTypes.length; i++) {
                ddlRoomType.append(new Option(roomTypes[i].Name, roomTypes[i].Id));
            }
        },

        BindRateTypeDdl: function () {
            var ddlRateType = $('#rateTypeDdl');
            var ddlRoomType = $('#roomTypeDdl');
            var rateTypeData = pmsSession.GetItem("roomratetypedata");
            if (!ddlRateType || !ddlRoomType || !rateTypeData) return;

            var rateTypes = $.parseJSON(rateTypeData);
            if (!rateTypes || rateTypes.length <= 0) return;

            ddlRateType.empty();
            ddlRateType.append(new Option("Select Type", "-1"));
            var roomTypeId = parseInt(ddlRoomType.val());
            if (roomTypeId > -1) {
                for (var i = 0; i < rateTypes.length; i++) {
                    if (rateTypes[i].RoomTypeId !== roomTypeId) continue;

                    ddlRateType.append(new Option(rateTypes[i].Name, rateTypes[i].Id));
                }
            }
        },

        AddBooking: function () {
            var bookingRequestDto = {};
            bookingRequestDto.Booking = {};
            var booking = {};
            
            if (!$('#dateFrom') || !$('#dateTo')
               || !$('#ddlAdults') || !$('#ddlChild')) return;

            booking.CheckinTime = $('#dateFrom').val();
            booking.CheckoutTime = $('#dateTo').val();
            booking.NoOfAdult = $('#ddlAdults').val();
            booking.NoOfChild = $('#ddlChild').val();
            booking.PropertyId = pmsSession.GetItem("propertyid");
            booking.GuestRemarks = $('#guestComments').val();
            booking.TransactionRemarks = "transaction";

            booking.RoomBookings = prepareRoomBookingDto();
            booking.Guests = prepareGuestDto();
            booking.Addresses = prepareAddressDto();
            
            if (!booking.RoomBookings || !booking.Guests || !booking.Addresses) {
                console.error('Room Booking can not be done.');
                alert("Room Booking can not be done.");
                return;
            }

            bookingRequestDto.Booking = booking;
            // add booking by api calling  
            pmsService.AddBooking(bookingRequestDto);           
        }        
    };
    
    function prepareAddressDto() {
        if (!$('#ddlCity') || !$('#ddlState') || !$('#ddlCountry')
            || !$('#zipCode') || !$('#address'))  return;

        var addresses = [];
        var address = {};

        address.City = $('#ddlCity').val();
        address.State = $('#ddlState').val();
        address.Country = $('#ddlCountry').val();
        address.ZipCode = $('#zipCode').val();
        address.Address1 = $('#address').val();
        address.GuestId = $('#hdnGuestId').val() == '' ? -1 : $('#hdnGuestId').val();
        //TODO: addresstype to be selected from address type ddl
        address.AddressTypeId = 1;

        if (address.AddressTypeId === '-1' || address.Address1 === '' || address.ZipCode === '' || address.City === '-1' || address.State === '-1' || address.Country === '-1') {
            console.error('Address details are missing.');
            alert("Address details are missing.");
            return null;
        }

        addresses.push(address);
        return addresses;
    }
        
    function prepareGuestDto() {
        if (!$('#ddlInitials') || !$('#fName') || !$('#lName')
            || !$('#phone') || !$('#address') || !$('#lName')
            || !$('#ddlCity') || !$('#ddlState') || !$('#ddlCountry')
            || !$('#zipCode') || !$('#email') || !$('#ddlIdType')
            || !$('#idnumber') || !$('#ddlIdState') || !$('#ddlIdCountry')
            || !$('#idexpiry') || !$('#dob')) return;

        var guests = [];
        var guest = {};
        var additionalGuest = {};
        guest.AdditionalGuests = [];
        guest.GuestMappings = [];

        // for new guest guestid should be -1 else guestid
        guest.Id = $('#hdnGuestId').val() == '' ? -1 : $('#hdnGuestId').val();
        guest.FirstName = $('#fName').val();
        guest.LastName = $('#lName').val();
        guest.MobileNumber = $('#phone').val();
        guest.EmailAddress = $('#email').val();
        guest.DOB = $('#dob').val();
        guest.Gender = $('#ddlInitials').val();
        guest.PhotoPath = "UploadedImage\\" + $("#uploadPhoto").get(0).files[0].name;
        
        if (guest.FirstName === '' || guest.LastName === '' || guest.EmailAddress === '') {
            console.error('Guest details are missing.');
            alert("Guest details are missing.");
            return null;
        } 

        guest.AdditionalGuests = prepareAdditionalGuestDto();
        guest.GuestMappings = prepareGuestIdDetailsDto();

        if (!guest.GuestMappings) {
            console.error('Guest Identification details are missing.');
            alert("Guest Id details are missing.");
            return null;
        }

        guests.push(guest);
        return guests;
    }

    function prepareGuestIdDetailsDto() {
        if (!$('#ddlIdType') || !$('#idDetails') || !$('#ddlIdState')
            || !$('#ddlIdCountry') || !$('#idExpiry') || !$('#ddlIdType')) return;

        var guestMapping = {};
        var guestMappings = [];

        guestMapping.IdTypeId = $('#ddlIdType').val();
        guestMapping.IdDetails = $('#idDetails').val();
        guestMapping.IdExpiryDate = $('#idExpiry').val();
        guestMapping.IdIssueState = $('#ddlIdState').val();
        guestMapping.IdIssueCountry = $('#ddlIdCountry').val();

        if (guestMapping.IdTypeId === '-1' || guestMapping.IdDetails === '' || guestMapping.IdExpiryDate === '') return null;

        guestMappings.push(guestMapping);
        return guestMappings;
    }

    function prepareAdditionalGuestDto() {
        var additionalGuest = {};
        var additionalGuests = [];

        //TODO:reading additonal guest info from grid 
        additionalGuest.FirstName = "Additional Fname";
        additionalGuest.LastName = "Additional Lname";
        additionalGuest.PhotoPath = "phhotopath";
        additionalGuest.IdDetails = "MYTT9000";
        additionalGuest.IdTypeId = 1;
        additionalGuest.Gender = "M";

        additionalGuests.push(additionalGuest);
        return additionalGuests;
    }

    function prepareRoomBookingDto() {
        if (!$('#rateTypeDdl') || !$('#roomTypeDdl') || !$('#roomddl')) return;

        var roomBookings = [];
        var roomBooking = {};
        roomBooking.Room = {};
        roomBooking.Guest = {};
        roomBooking.Room.RateType = {};
        roomBooking.Room.RoomType = {};

        roomBooking.Room.RateType.Id = $('#rateTypeDdl').val();
        roomBooking.Room.RoomType.Id = $('#roomTypeDdl').val();
        roomBooking.Room.Id = $('#roomddl').val();
        
        if (roomBooking.Room.RateType.Id === '-1' || roomBooking.Room.RoomType.Id === '-1' || roomBooking.Room.Id === '-1') return null;

        roomBooking.Guest.Id = $('#hdnGuestId').val() == '' ? -1 : $('#hdnGuestId').val();

        roomBookings.push(roomBooking);
        return roomBookings;
    }

    function getRoomTypes() {
        args.propertyId = pmsSession.GetItem("propertyid");;
        var roomTypeData = pmsSession.GetItem("roomtypedata");
        if (!roomTypeData) {
            // get room types by api calling  
            pmsService.GetRoomTypeByProperty(args);
        } else {
            window.GuestCheckinManager.BindRoomTypeDdl();
        }
    }

    function getRoomRateTypes() {
        args.propertyId = pmsSession.GetItem("propertyid");;
        var roomRateTypeData = pmsSession.GetItem("roomratetypedata");
        if (!roomRateTypeData) {
            // get room rate types by api calling  
            pmsService.GetRateTypeByProperty(args);
        }
    }
    
    function getRooms(){
        args.propertyId = pmsSession.GetItem("propertyid");;
        var roomData = pmsSession.GetItem("roomdata");
        if (!roomData) {
            // get room by api calling  
            pmsService.GetRoomByProperty(args);
        }
    }
    
    function getCurrentDate() {
        // date format yyyy/mm/dd
        var dt = new Date();
        var month = dt.getMonth() + 1;
        var day = dt.getDate();
        var dateOutput = dt.getFullYear() + '/' +
            (month < 10 ? '0' : '') + month + '/' +
            (day < 10 ? '0' : '') + day;

        var time = dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds();
        return dateOutput + time;
    }

    function ajaxHandlers() {

        // ajax handlers start

        pmsService.Handlers.OnAddBookingSuccess = function (data) {
            console.log(data.StatusDescription);
            if (window.FormData !== undefined) {
                // if success upload image of guest
                var data = new FormData();
                var files = $("#uploadPhoto").get(0).files;
                // Add the uploaded image content to the form data collection
                if (files.length > 0) {
                    data.append("UploadedImage", files[0]);
                }
                pmsService.UploadImage(data);
            }
            alert(data.StatusDescription);
        };

        pmsService.Handlers.OnAddBookingFailure = function () {
            // show error log
            console.error("Room Booking is failed");
        };

        pmsService.Handlers.OnGetRoomTypeByPropertySuccess = function (data) {
            //storing room type data into session storage
            pmsSession.SetItem("roomtypedata", JSON.stringify(data.RoomTypes));
            window.GuestCheckinManager.BindRoomTypeDdl();
        };
        pmsService.Handlers.OnGetRoomTypeByPropertyFailure = function () {
            // show error log
            console.error("Get Room type call failed");
        };

        pmsService.Handlers.OnGetRateTypeByPropertySuccess = function (data) {
            //storing room rate type data into session storage
            pmsSession.SetItem("roomratetypedata", JSON.stringify(data.RateTypes));
        };
        pmsService.Handlers.OnGetRateTypeByPropertyFailure = function () {
            // show error log
            console.error("Get Room rate type call failed");
        };
        
        pmsService.Handlers.OnGetRoomByPropertySuccess = function (data) {
            //storing room data into session storage
            pmsSession.SetItem("roomdata", JSON.stringify(data.Rooms));
        };
        pmsService.Handlers.OnGetRoomByPropertyFailure = function () {
            // show error log
            console.error("Get Room call failed");
        };

        pmsService.Handlers.OnUploadImageSuccess = function (data) {
            console.log("Image upload success");
        };
        pmsService.Handlers.OnUploadImageFailure = function () {
            // show error log
            console.error("Image upload failed");
        };
        // ajax handlers end
    }

    win.GuestCheckinManager = guestCheckinManager;
}(window));
