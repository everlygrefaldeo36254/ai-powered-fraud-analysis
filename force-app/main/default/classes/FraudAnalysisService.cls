public with sharing class FraudAnalysisService {

    public static FraudAnalysisResult analyzeAndSave(Id fraudCaseId) {
        Fraud_Case__c fraudCase = [
            SELECT Id, Customer_Name__c, Amount__c, Location__c,
                   Channel__c, Description__c, Status__c
            FROM Fraud_Case__c
            WHERE Id = :fraudCaseId
            LIMIT 1
        ];

        String prompt = buildFraudPrompt(fraudCase);
        String cleanJson = OpenAIHttpService.analyzeFraud(prompt);
        FraudAnalysisResult result = parseFraudRiskResult(cleanJson);

        saveAnalysisRecord(fraudCase.Id, prompt, cleanJson, result);
        updateFraudCase(fraudCase.Id, result);

        return result;
    }

    private static FraudAnalysisResult parseFraudRiskResult(String cleanJson) {
        Map<String, Object> parsed =
            (Map<String, Object>) JSON.deserializeUntyped(cleanJson);

        FraudAnalysisResult result = new FraudAnalysisResult();
        result.riskLevel = (String) parsed.get('riskLevel');
        result.summary = (String) parsed.get('summary');
        result.recommendedAction = (String) parsed.get('recommendedAction');

        return result;
    }

    private static void saveAnalysisRecord(
        Id fraudCaseId,
        String prompt,
        String aiResponse,
        FraudAnalysisResult result
    ) {
        insert new AI_Fraud_Analysis__c(
            Fraud_Case__c = fraudCaseId,
            Prompt__c = prompt,
            AI_Response__c = aiResponse,
            Risk_Level__c = result.riskLevel,
            Recommendation__c = result.recommendedAction,
            User__c = UserInfo.getUserId()
        );
    }

    private static void updateFraudCase(
        Id fraudCaseId,
        FraudAnalysisResult result
    ) {
        update new Fraud_Case__c(
            Id = fraudCaseId,
            AI_Risk_Level__c = result.riskLevel,
            AI_Summary__c = result.summary,
            Recommended_Action__c = result.recommendedAction,
            Status__c = 'AI Reviewed'
        );
    }

    private static String buildFraudPrompt(Fraud_Case__c fraudCase) {
        return
            'You are a fraud analyst.\n\n' +
            'Analyze this suspicious transaction/case.\n\n' +
            'Return ONLY valid JSON.\n' +
            'Use this exact structure:\n' +
            '{\n' +
            '  "riskLevel": "Low | Medium | High",\n' +
            '  "summary": "short explanation",\n' +
            '  "recommendedAction": "next action"\n' +
            '}\n\n' +
            'Fraud Case Details:\n' +
            'Customer Name: ' + fraudCase.Customer_Name__c + '\n' +
            'Amount: ' + fraudCase.Amount__c + '\n' +
            'Location: ' + fraudCase.Location__c + '\n' +
            'Channel: ' + fraudCase.Channel__c + '\n' +
            'Description: ' + fraudCase.Description__c + '\n' +
            'Status: ' + fraudCase.Status__c;
    }
}