public class StringListTest {

    // Public static method to generate a list of formatted strings
    public static List<String> generateStringList(Integer count) {
        // Initialize the list to hold the strings
        List<String> stringList = new List<String>();

        // Validate the input to ensure it's not negative
        if (count == null || count < 0) {
            return stringList; // Return an empty list for invalid input
        }

        // Loop to populate the list with formatted strings
        for (Integer i = 0; i < count; i++) {
            stringList.add('Test ' + i);
        }

        // Return the generated list
        return stringList;
    }
}