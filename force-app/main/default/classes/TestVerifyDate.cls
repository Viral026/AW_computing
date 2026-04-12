@IsTest
public class TestVerifyDate {
    @IsTest
    static void testCheckDates_within30Days() {
        // Test case where date2 is within 30 days of date1
        Date date1 = Date.today();
        Date date2 = date1.addDays(10); // within 30 days
        Date result = VerifyDate.CheckDates(date1, date2);

        // Assert that date2 is returned
        System.assertEquals(date2, result, 'Date2 should be returned as it is within 30 days of date1.');
    }

    @IsTest
    static void testCheckDates_outside30Days() {
        // Test case where date2 is more than 30 days from date1
        Date date1 = Date.today();
        Date date2 = date1.addDays(31); // outside 30 days
        Date expectedEndOfMonth = Date.newInstance(date1.year(), date1.month(), Date.daysInMonth(date1.year(), date1.month()));
        Date result = VerifyDate.CheckDates(date1, date2);

        // Assert that the end of the month is returned
        System.assertEquals(expectedEndOfMonth, result, 'End of the month should be returned as date2 is outside 30 days.');
    }

    @IsTest
    static void testCheckDates_date2InThePast() {
        // Test case where date2 is in the past
        Date date1 = Date.today();
        Date date2 = date1.addDays(-1); // in the past
        Date expectedEndOfMonth = Date.newInstance(date1.year(), date1.month(), Date.daysInMonth(date1.year(), date1.month()));
        Date result = VerifyDate.CheckDates(date1, date2);

        // Assert that the end of the month is returned
        System.assertEquals(expectedEndOfMonth, result, 'End of the month should be returned as date2 is in the past.');
    }

    @IsTest
    static void testEdgeCase_EndOfMonth() {
        // Test edge case where the input date is already the end of the month
        Date date1 = Date.newInstance(2024, 2, 29); // Leap year February
        Date date2 = date1.addDays(10); // date2 within 30 days
        Date result = VerifyDate.CheckDates(date1, date2);

        // Assert that date2 is returned as it is within 30 days
        System.assertEquals(date2, result, 'Date2 should be returned as it is within 30 days of date1.');
    }

    @IsTest
    static void testEdgeCase_FirstDayOfMonth() {
        // Test edge case where date1 is the first day of the month
        Date date1 = Date.newInstance(2024, 3, 1); // March 1, 2024
        Date date2 = date1.addDays(31); // date2 exactly 31 days after date1
        Date expectedEndOfMonth = Date.newInstance(2024, 3, 31); // End of March
        Date result = VerifyDate.CheckDates(date1, date2);

        // Assert that the end of the month is returned as date2 is outside 30 days
        System.assertEquals(expectedEndOfMonth, result, 'End of the month should be returned as date2 is outside 30 days.');
    }
}