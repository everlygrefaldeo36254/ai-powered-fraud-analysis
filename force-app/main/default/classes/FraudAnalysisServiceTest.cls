@IsTest
private class FraudAnalysisServiceTest {

    @IsTest
    static void analyzeAndSave_shouldCreateAnalysisAndUpdateFraudCase() {
        Fraud_Case__c fraudCase = new Fraud_Case__c(
            Customer_Name__c = 'John Doe',
            Amount__c = 250000,
            Location__c = 'Russia',
            Channel__c = 'Mobile App',
            Description__c = '7 failed OTP attempts',
            Status__c = 'New'
        );

        insert fraudCase;

        Test.setMock(HttpCalloutMock.class, new OpenAIResponsesMock());

        Test.startTest();
        FraudAnalysisResult result =
            FraudAnalysisService.analyzeAndSave(fraudCase.Id);
        Test.stopTest();

        System.assertEquals('High', result.riskLevel);
        System.assertEquals(
            'Multiple failed OTP attempts indicate suspicious activity.',
            result.summary
        );
        System.assertEquals(
            'Block the transaction and verify the customer.',
            result.recommendedAction
        );

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
        System.assertEquals(
            'Multiple failed OTP attempts indicate suspicious activity.',
            updatedCase.AI_Summary__c
        );
        System.assertEquals(
            'Block the transaction and verify the customer.',
            updatedCase.Recommended_Action__c
        );
        System.assertEquals('AI Reviewed', updatedCase.Status__c);

        AI_Fraud_Analysis__c analysis = [
            SELECT Fraud_Case__c,
                   Prompt__c,
                   AI_Response__c,
                   Risk_Level__c,
                   Recommendation__c,
                   User__c
            FROM AI_Fraud_Analysis__c
            WHERE Fraud_Case__c = :fraudCase.Id
            LIMIT 1
        ];

        System.assertEquals(fraudCase.Id, analysis.Fraud_Case__c);
        System.assertNotEquals(null, analysis.Prompt__c);
        System.assertNotEquals(null, analysis.AI_Response__c);
        System.assertEquals('High', analysis.Risk_Level__c);
        System.assertEquals(
            'Block the transaction and verify the customer.',
            analysis.Recommendation__c
        );
        System.assertEquals(UserInfo.getUserId(), analysis.User__c);
    }
}