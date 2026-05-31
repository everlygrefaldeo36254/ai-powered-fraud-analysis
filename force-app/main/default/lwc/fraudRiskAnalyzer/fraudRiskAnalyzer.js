import { LightningElement, api, track } from 'lwc';
import analyzeFraudRisk from '@salesforce/apex/FraudRiskAnalyzerController.analyzeFraudRisk';

export default class FraudRiskAnalyzer extends LightningElement {
    @api recordId;

    @track riskLevel;
    @track summary;
    @track recommendedAction;
    @track isLoading = false;
    @track errorMessage;

    async handleAnalyze() {
        this.isLoading = true;
        this.errorMessage = null;

        try {
            const result = await analyzeFraudRisk({
                fraudCaseId: this.recordId
            });

            this.riskLevel = result.riskLevel;
            this.summary = result.summary;
            this.recommendedAction = result.recommendedAction;
        } catch (error) {
            this.errorMessage =
                error?.body?.message || error?.message || 'Something went wrong.';
        } finally {
            this.isLoading = false;
        }
    }
}