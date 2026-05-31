@IsTest
private class FraudAnalysisQueueableTest {

    @IsTest
    static void queueable_shouldProcessFraudAnalysisAsync() {
        Fraud_Case__c fraudCase = new Fraud_Case__c(
            Customer_Name__c = 'Jane Smith',
            Amount__c = 150000,
            Location__c = 'Unknown Location',
            Channel__c = 'Web',
            Description__c = 'Multiple login failures before transaction',
            Status__c = 'New'
        );

        insert fraudCase;

        Test.setMock(HttpCalloutMock.class, new OpenAIResponsesMock());

        Test.startTest();
        System.enqueueJob(new FraudAnalysisQueueable(fraudCase.Id));
        Test.stopTest();

        Fraud_Case__c updatedCase = [
            SELECT AI_Risk_Level__c,
                   AI_Summary__c,
                   Recommended_Action__c,
                   Status__c
            FROM Fraud_Case__c
            WHERE Id = :fraudCase.Id
            LIMIT 1
        ];

        System.assertEquals('High', updatedCase.AI_Risk_Level__c);
        System.assertEquals('AI Reviewed', updatedCase.Status__c);

        Integer analysisCount = [
            SELECT COUNT()
            FROM AI_Fraud_Analysis__c
            WHERE Fraud_Case__c = :fraudCase.Id
        ];

        System.assertEquals(1, analysisCount);
    }
}