@IsTest
private class FraudRiskAnalyzerControllerTest {

    @IsTest
    static void analyzeFraudRisk_shouldEnqueueJobAndReturnProcessingMessage() {
        Fraud_Case__c fraudCase = new Fraud_Case__c(
            Customer_Name__c = 'Test Customer',
            Amount__c = 50000,
            Location__c = 'Singapore',
            Channel__c = 'ATM',
            Description__c = 'Suspicious withdrawal pattern',
            Status__c = 'New'
        );

        insert fraudCase;

        Test.setMock(HttpCalloutMock.class, new OpenAIResponsesMock());

        Test.startTest();

        FraudRiskAnalyzerController.FraudRiskResult result =
            FraudRiskAnalyzerController.analyzeFraudRisk(fraudCase.Id);

        Test.stopTest();

        System.assertEquals('Processing', result.riskLevel);
        System.assertEquals(
            'Fraud risk analysis has started.',
            result.summary
        );
        System.assertEquals(
            'Refresh the record shortly to view the AI result.',
            result.recommendedAction
        );

        Fraud_Case__c updatedCase = [
            SELECT AI_Risk_Level__c,
                   Status__c
            FROM Fraud_Case__c
            WHERE Id = :fraudCase.Id
            LIMIT 1
        ];

        System.assertEquals('High', updatedCase.AI_Risk_Level__c);
        System.assertEquals('AI Reviewed', updatedCase.Status__c);
    }
}