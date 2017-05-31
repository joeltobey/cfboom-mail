component
    singleton="true"
    extends="cfboom.lang.Object"
    displayname="Class EmailService"
    output="false"
{
     /**
     * @debugEmail.inject coldbox:setting:debugEmail@cfboom-mail
     * @noReplyEmail.inject coldbox:setting:noReplyEmail@cfboom-mail
     */
    public cfboom.mail.models.EmailService function init(required string debugEmail, required string noReplyEmail) {
        variables['DEBUG_EMAIL'] = arguments.debugEmail;
        variables['NO_REPLY_EMAIL'] = arguments.noReplyEmail;
        return this;
    }

    /**
     * @argumentStruct.hint This optional passes a struct of arguments found in the content file.
     * @subject.hint This specifies the subject line of the email.
     * @to.hint This specifies to whom the email is to be sent.
     * @type.hint This specifies the MIME type. 'html' means send html-only version, 'text' means send text-only version, 'html/text' means send both an html and a text version
     * @toName.hint This optionally specifies the recipient's name in the to header field.
     * @from.hint This optionally specifies who the email is from.
     * @fromName.hint This optionally specifies the recipient's name in the to header field.
     * @htmlPath.hint This optionally provides the path to the file that contains the html design. This should only be populated if html is one of the types of the email.
     * @textPath.hint This optionally provides the path to the file that contains the text content. This should only be populated if text is one of the types of the email.
     * @cc.hint This optionally provides a 'CC' for the email.
     * @bcc.hint This optionally provides a 'BCC' for the email.
     */
    public void function sendDebugEmail(
        struct argumentStruct = {},
        string subject = "Uncaught Error",
        string to = DEBUG_EMAIL,
        string type = "html",
        string toName = "",
        string from = NO_REPLY_EMAIL,
        string fromName = "",
        string body = "",
        string htmlPath = "/cfboom/mail/includes/email/html/debug.cfm",
        string textPath = "",
        string cc = "",
        string bcc = ""
    ) {
        var emailStruct = arguments.argumentStruct;
        var isGmail = false;
        if (findNoCase("gmail", arguments.to) || findNoCase("gmail", arguments.cc) || findNoCase("gmail", arguments.bcc)) isGmail = true;
        var hasHtml = false;
        var hasText = false;
        var htmlOnly = false;
        var textOnly = false;
        if (findNoCase("html", arguments.type))
            hasHtml = true;
        if (findNoCase("text", arguments.type))
            hasText = true;
        if (hasHtml && !hasText)
            htmlOnly = true;
        if (hasText && !hasHtml)
            textOnly = true;

        if (structKeyExists(arguments,"toName") && len(arguments.toName)) {
            arguments.to = arguments.toName & " <" & arguments.to & ">";
        }

        if (structKeyExists(arguments,"fromName") && len(arguments.fromName)) {
            arguments.from = arguments.fromName & " <" & arguments.from & ">";
        }

        var mailService = new mail();
        mailService.setSubject( arguments.subject );
        mailService.setTo( arguments.to );
        mailService.setFrom( arguments.from );
        if (htmlOnly)
            mailService.setType("html");
        if (textOnly)
            mailService.setType("text");
        mailService.setCharset("utf-8");
        if (len(arguments.cc))
            mailService.setCc( arguments.cc );
        if (len(arguments.bcc))
            mailService.setBcc( arguments.bcc );
        if (len(arguments.body)) {
            mailService.setBody( arguments.body );
        } else {
            saveContent variable="emailBody" {include arguments.htmlPath;}
            mailService.setBody( emailbody );
        }
        mailService.send();
    }

    public string function getEmailDomain(required string email) {
        return right(arguments.email, len(arguments.email) - find("@", arguments.email));
    }
}