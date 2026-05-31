public with sharing class HttpCalloutService {

    public class HttpRequestConfig {
        public String endpoint;
        public String method;
        public Map<String, String> headers;
        public String body;
        public Integer timeoutMs;
    }

    public static HttpResponse send(HttpRequestConfig config) {
        HttpRequest request = buildRequest(config);

        Http http = new Http();
        HttpResponse response = http.send(request);

        validateResponse(response);

        return response;
    }

    private static HttpRequest buildRequest(HttpRequestConfig config) {
        HttpRequest request = new HttpRequest();

        request.setEndpoint(config.endpoint);
        request.setMethod(config.method);

        if (config.timeoutMs != null) {
            request.setTimeout(config.timeoutMs);
        }

        if (config.headers != null) {
            for (String headerName : config.headers.keySet()) {
                request.setHeader(headerName, config.headers.get(headerName));
            }
        }

        if (String.isNotBlank(config.body)) {
            request.setBody(config.body);
        }

        return request;
    }

    private static void validateResponse(HttpResponse response) {
        Integer statusCode = response.getStatusCode();

        if (statusCode >= 200 && statusCode < 300) {
            return;
        }

        throw new AuraHandledException(
            'HTTP callout failed: ' +
            statusCode +
            ' - ' +
            response.getBody()
        );
    }
}