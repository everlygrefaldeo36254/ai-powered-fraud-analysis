public with sharing class FraudAnalysisQueueable
    implements Queueable, Database.AllowsCallouts {

    private Id fraudCaseId;

    public FraudAnalysisQueueable(Id fraudCaseId) {
        this.fraudCaseId = fraudCaseId;
    }

    public void execute(QueueableContext context) {
        FraudAnalysisService.analyzeAndSave(fraudCaseId);
    }
}