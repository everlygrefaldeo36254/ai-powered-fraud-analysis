public with sharing class OpenAIHttpService {

    private static final String NAMED_CREDENTIAL = 'callout:OpenAI_API';
    private static final String RESPONSES_PATH = '/v1/responses';
    private static final String MODEL = 'gpt-4.1-mini';
    private static final Integer TIMEOUT_MS = 120000;

    // NOTE:
    // The OpenAI API key is temporarily hardcoded because this project prioritizes
    // rapid prototyping and minimizing integration configuration overhead within
    // a scratch-org/demo environment.
    //
    // While Salesforce supports more secure credential-management approaches
    // (External Credentials, Named Credential custom headers, Secret Manager),
    // those setups require additional metadata, permission mappings, and org
    // configuration steps that would significantly increase implementation time
    // for this portfolio prototype.
    //
    // The primary focus of this project is to demonstrate:
    // - Apex HTTP callouts
    // - AI API integration
    // - reusable integration architecture
    // - JSON request/response handling
    // - LWC ↔ Apex orchestration
    //
    // In a production implementation, the API key should be externalized into
    // a secure credential-management solution.
    private static final String API_KEY = 'REPLACE_WITH_OPENAI_API_KEY';

    public static String analyzeFraud(String prompt) {
        HttpResponse response =
            HttpCalloutService.send(buildOpenAIRequest(prompt));

        return extractOutputText(response.getBody());
    }

    private static HttpCalloutService.HttpRequestConfig buildOpenAIRequest(String prompt) {
        HttpCalloutService.HttpRequestConfig config =
            new HttpCalloutService.HttpRequestConfig();

        config.endpoint = NAMED_CREDENTIAL + RESPONSES_PATH;
        config.method = 'POST';
        config.timeoutMs = TIMEOUT_MS;
        config.headers = new Map<String, String>{
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer ' + API_KEY
        };
        config.body = JSON.serialize(new Map<String, Object>{
            'model' => MODEL,
            'input' => prompt
        });

        return config;
    }

    private static String extractOutputText(String rawResponse) {
        Map<String, Object> parsed =
            (Map<String, Object>) JSON.deserializeUntyped(rawResponse);

        List<Object> output = (List<Object>) parsed.get('output');
        Map<String, Object> firstOutput = (Map<String, Object>) output[0];

        List<Object> content = (List<Object>) firstOutput.get('content');
        Map<String, Object> firstContent = (Map<String, Object>) content[0];

        String text = (String) firstContent.get('text');

        return cleanJsonFence(text);
    }

    private static String cleanJsonFence(String text) {
        if (String.isBlank(text)) {
            return text;
        }

        return text
            .replace('```json', '')
            .replace('```', '')
            .trim();
    }
}