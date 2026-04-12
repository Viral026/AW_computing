@isTest
private class AnimalLocatorTest {
    @isTest 
    static void testGetAnimalNameById() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String actualValue = AnimalLocator.getAnimalNameById(1);
        System.assertEquals('chicken', actualValue);
    }
}