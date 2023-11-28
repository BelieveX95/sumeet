public class WeatherUpdateQueueable implements Queueable {
    private List<Account> accountsToUpdate;

    public WeatherUpdateQueueable(List<Account> accountsToUpdate) {
        this.accountsToUpdate = accountsToUpdate;
    }

    public void execute(QueueableContext context) {
        String apiKey = 'YOUR_API_KEY_HERE';
        List<Account> updatedAccounts = new List<Account>();

        for (Account acc : accountsToUpdate) {
            if (acc.BillingCity != null) {
                String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=' + acc.BillingCity + '&appid=' + apiKey;
                                    System.debug('apiUrl: ' + apiUrl);

                HttpRequest request = new HttpRequest();
                request.setEndpoint(apiUrl);
                request.setMethod('GET');
                HttpResponse response = new Http().send(request);

                if (response.getStatusCode() == 200) {
                    Map<String, Object> weatherData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    String weatherDescription = (String) ((Map<String, Object>) ((List<Object>) weatherData.get('weather')).get(0)).get('description');
                    String temperature = String.valueOf(((Map<String, Object>) weatherData.get('main')).get('temp'));
                    acc.Weather_Deatils__c = 'Weather: ' + weatherDescription + ', Temperature: ' + temperature;
                                        System.debug('weatherDescription'+weatherDescription);
                    System.debug('temperature: ' + temperature);

                    updatedAccounts.add(acc);
                } else {
                    System.debug('API request failed with status code: ' + response.getStatusCode());
                }
            }
        }

        if (!updatedAccounts.isEmpty()) {
                                System.debug('updatedAccounts: ' + updatedAccounts);

            update updatedAccounts;
        }
    }
}