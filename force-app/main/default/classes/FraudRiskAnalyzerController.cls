public with sharing class FraudRiskAnalyzerController {

    public class FraudRiskResult {
        @AuraEnabled public String riskLevel;
        @AuraEnabled public String summary;
        @AuraEnabled public String recommendedAction;
    }

    @AuraEnabled
    public static FraudRiskResult analyzeFraudRisk(Id fraudCaseId) {
        System.enqueueJob(new FraudAnalysisQueueable(fraudCaseId));

        FraudRiskResult result = new FraudRiskResult();
        result.riskLevel = 'Processing';
        result.summary = 'Fraud risk analysis has started.';
        result.recommendedAction = 'Refresh the record shortly to view the AI result.';

        return result;
    }
}