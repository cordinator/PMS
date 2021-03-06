﻿using PMS.Resources.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PmsEntity = PMS.Resources.Entities;

namespace PMS.Resources.DAL
{
    public interface IDalFactory
    {
        void LogExceptionToDb(PmsEntity.ExceptionLog additionalExData);
        bool AddBooking(int propertyId, string bookingXml, ref int bookingId, ref int guestId, ref int roomBookingId);
        List<PmsEntity.Booking> GetBooking(int propertyId, DateTime startDate, DateTime endDate);
        int AddProperty(PmsEntity.Property property);
        bool UpdateProperty(PmsEntity.Property property);
        bool DeleteProperty(int propertyId);
        List<PmsEntity.Property> GetAllProperty();
        List<PmsEntity.Property> GetPropertyForAccess();
        int AddPropertyType(PmsEntity.PropertyType propertyType);
        bool UpdatePropertyType(PmsEntity.PropertyType propertyType);
        bool DeletePropertyType(int propertyTypeId);
        List<PmsEntity.PropertyType> GetAllPropertyType();
        
        //Room API
        bool AddRoom(int propertyId, string roomXml);
        bool UpdateRoom(int propertyId, string roomXml);
        bool DeleteRoom(int roomId);
        List<PmsEntity.Room> GetRoomByProperty(int propertyId);

        int AddRateType(PmsEntity.RateType rateType);
        bool UpdateRateType(PmsEntity.RateType rateType);
        bool DeleteRateType(int rateTypeId);
        List<PmsEntity.RateType> GetRateTypeByProperty(int propertyId);

        //Payment Type Methods
        int AddPaymentType(PmsEntity.PaymentType paymentType);
        bool UpdatePaymentType(PmsEntity.PaymentType paymentType);
        bool DeletePaymentType(int paymentTypeId);
        List<PmsEntity.PaymentType> GetPaymentTypeByProperty(int propertyId);

        //Property Floor Methods
        int AddFloor(PmsEntity.PropertyFloor propertyFloor);
        bool UpdateFloor(PmsEntity.PropertyFloor propertyFloor);
        bool DeleteFloor(int propertyFloorId);
        List<PmsEntity.PropertyFloor> GetFloorsByProperty(int propertyId);

        //Extra Charges
        int AddExtraCharge(PmsEntity.ExtraCharge extraCharge);
        bool UpdateExtraCharge(PmsEntity.ExtraCharge extraCharge);
        bool DeleteExtraCharge(int extraChargeId);
        List<PmsEntity.ExtraCharge> GetExtraCharges(int propertyId);

        //Taxes
        int AddTax(PmsEntity.Tax tax);
        bool UpdateTax(PmsEntity.Tax tax);
        bool DeleteTax(int TaxId);
        List<PmsEntity.Tax> GetTaxByProperty(int propertyId);

        int AddRoomType(PmsEntity.RoomType roomType);
        bool UpdateRoomType(PmsEntity.RoomType roomType);
        bool DeleteRoomType(int roomTypeId);
        List<PmsEntity.RoomType> GetRoomTypeByProperty(int propertyId);
        int AddRoomPrice(PmsEntity.RoomPricing roomPrice);
        bool UpdateRoomPrice(PmsEntity.RoomPricing roomPrice);
        bool DeleteRoomPrice(int priceId);
        List<PmsEntity.RoomPricing> GetRoomPriceByProperty(int propertyId);
        int AddRoomStatus(PmsEntity.RoomStatus roomStatus);
        bool UpdateRoomStatus(PmsEntity.Room room);
        bool DeleteRoomStatus(int statusId);
        List<PmsEntity.RoomStatus> GetRoomStatus();
        int AddReward(PmsEntity.GuestReward reward);
        bool UpdateReward(PmsEntity.GuestReward reward);
        bool DeleteReward(int rewardId);
        List<PmsEntity.GuestReward> GetAllReward();
        List<PmsEntity.GuestReward> GetRewardByGuestId(int guestId);
        int AddRewardCategory(PmsEntity.RewardCategory rewardCategory);
        bool UpdateRewardCategory(PmsEntity.RewardCategory rewardCategory);
        bool DeleteRewardCategory(int catId);
        List<PmsEntity.RewardCategory> GetAllRewardCategory();
        List<PmsEntity.Room> GetRoomByDate(int propertyId, DateTime checkinDate , DateTime checkoutDate);
        List<PmsEntity.Booking> GetGuestHistory(int guestId);
        bool UpdateBooking(PmsEntity.Booking booking);
        List<PmsEntity.State> GetStateByCountry(int id);
        List<PmsEntity.City> GetCityByState(int id);
        List<PmsEntity.Country> GetCountry();
        List<PmsEntity.Guest> GetAllGuest();
        List<PmsEntity.Tax> GetPaymentCharges(int? propertyId, int? roomTypeId, int? rateTypeId, int? noOfHours, bool? IsHourly, int? roomId);
        int AddInvoice(int propertyId, string invoiceXml);
        PmsEntity.Invoice GetInvoiceById(int invoiceId, int? propertyId, int? roomTypeId, int? rateTypeId, int? noOfHours, int? noOfDays, bool? IsHourly, int? roomId);
        PmsEntity.Booking GetBookingById(int bookingId);
        List<PmsEntity.RateType> GetRoomRateByProperty(int propertyId);
        bool AddRoomRate(int propertyId, string rateXml);
        bool UpdateRoomRate(int propertyId, string rateXml);
        bool DeleteRoomRate(int rateId);
        List<PmsEntity.Booking> GetBookingTransaction(DateTime? startDate, DateTime? endDate, string guestName, string roomType, decimal? minAmountPaid, decimal? maxAmountPaid, string paymentMode, bool? transactionStatus, string propertyId, out List<BookingSummary> bookingSummary);
        bool UpdateStatus(List<PmsEntity.Booking> booking);
        bool DeleteBooking(int bookingId);
        PmsEntity.User GetValidUser(string loginName, string password);

        //Expense category Methods
        int AddExpenseCategory(PmsEntity.ExpenseCategory expenseCategory);
        bool UpdateExpenseCategory(PmsEntity.ExpenseCategory expenseCategory);
        bool DeleteExpenseCategory(int expenseCategoryId);
        List<PmsEntity.ExpenseCategory> GetExpenseCategoryByProperty(int propertyId);

        //Expense methods
        int AddExpense(PmsEntity.Expense expense);
        bool UpdateExpense(PmsEntity.Expense expense);
        bool DeleteExpense(int expenseId);
        List<PmsEntity.Expense> GetExpenseBySearch(DateTime? startDate, DateTime? endDate, int? paymentId, int? expenseCategoryId,
            decimal? amountPaidMin, decimal? amountPaidMax, int? propertyId);

        DataTable GetShiftReport(DateTime? startDate, DateTime? endDate, int? propertyId);
        DataTable GetConsolidatedShiftReport(DateTime? startDate, DateTime? endDate, int? propertyId);
        DataTable GetManagerData(DateTime startDate, DateTime endDate, int propertyId);
        DataTable GetConsolidatedManagerData(DateTime startDate, DateTime endDate, int propertyId, int option);
        List<PmsEntity.GuestSummary> GETGuestSummary(int propertyId, DateTime currentDate);

        //user methods
        int AddUser(PmsEntity.User user);
        bool UpdateUser(PmsEntity.User user);
        bool DeleteUser(int userId);

        List<PmsEntity.User> GetAllUser();
        List<PmsEntity.Functionality> GetAllFunctionality();

        List<PmsEntity.Functionality> GetFunctionalityByUserId(int userId);
        bool InsertUserAccess(int userId, string functionalities, string properties, string createdBy);


        //Guest methods
        int AddGuest(PmsEntity.Guest guest);
        bool UpdateGuest(PmsEntity.Guest guest);
        bool DeleteGuest(int guestId);
        List<PmsEntity.Guest> GetAllGuest(bool fullInfo);

        bool CancelReservation(int bookingId);

        bool UpdatePassword(int UserId, string CurrentPassword, string NewPassword);

    }
}

