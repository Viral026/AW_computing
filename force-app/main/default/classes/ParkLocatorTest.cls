@isTest
private class ParkLocatorTest {
    @isTest static void testCallout() {
        // Set the mock callout class
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        
        // Call the method that invokes the callout
        String[] parks = ParkLocator.country('United States');
        
        // Verify the results
        System.assertEquals(3, parks.size());
        System.assertEquals('Yellowstone', parks[0]);
        System.assertEquals('Yosemite', parks[1]);
        System.assertEquals('Grand Canyon', parks[2]);
    }
}