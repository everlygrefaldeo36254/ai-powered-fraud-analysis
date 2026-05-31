@IsTest
public class OpenAIResponsesMock implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json');

        res.setBody(
            '{' +
            '"output":[' +
                '{' +
                    '"content":[' +
                        '{' +
                            '"text":"{\\"riskLevel\\":\\"High\\",\\"summary\\":\\"Multiple failed OTP attempts indicate suspicious activity.\\",\\"recommendedAction\\":\\"Block the transaction and verify the customer.\\"}"' +
                        '}' +
                    ']' +
                '}' +
            ']' +
            '}'
        );

        return res;
    }
}