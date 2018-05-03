/*
 * Copyright 2016-2017 Joel Tobey <joeltobey@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Class EmailService
 */
component singleton="true"
  displayname="Class EmailService"
  output="false"
{
  /**
   * @debugEmail.inject coldbox:setting:debugEmail@cfboom-mail
   * @noReplyEmail.inject coldbox:setting:noReplyEmail@cfboom-mail
   * @server.inject coldbox:setting:server@cfboom-mail
   * @port.inject coldbox:setting:port@cfboom-mail
   * @useSSL.inject coldbox:setting:useSSL@cfboom-mail
   * @username.inject coldbox:setting:username@cfboom-mail
   * @password.inject coldbox:setting:password@cfboom-mail
   */
  public cfboom.mail.models.EmailService function init( required string debugEmail,
                                                        required string noReplyEmail,
                                                        required string server,
                                                        required numeric port,
                                                        required boolean useSSL,
                                                        required string username,
                                                        required string password ) {
    variables['DEBUG_EMAIL'] = arguments.debugEmail;
    variables['NO_REPLY_EMAIL'] = arguments.noReplyEmail;
    variables['SMTP_SERVER'] = arguments.server;
    variables['SMTP_PORT'] = arguments.port;
    variables['SMTP_SSL'] = arguments.useSSL;
    variables['SMTP_USERNAME'] = arguments.username;
    variables['SMTP_PASSWORD'] = arguments.password;
    return this;
  }

  /**
   * Construct and send an email the same every time.
   *
   * @to.hint This specifies to whom the email is to be sent.
   * @subject.hint This specifies the subject line of the email.
   * @argumentStruct.hint This optional passes a struct of arguments found in the content file.
   * @type.hint This specifies the MIME type. 'html' means send html-only version, 'text' means send text-only version, 'html/text' means send both an html and a text version
   * @toName.hint This optionally specifies the recipient's name in the to header field.
   * @from.hint This optionally specifies who the email is from.
   * @fromName.hint This optionally specifies the recipient's name in the to header field.
   * @htmlPath.hint This optionally provides the path to the file that contains the html design. This should only be populated if html is one of the types of the email.
   * @textPath.hint This optionally provides the path to the file that contains the text content. This should only be populated if text is one of the types of the email.
   * @cc.hint This optionally provides a 'CC' for the email.
   * @bcc.hint This optionally provides a 'BCC' for the email.
   */
  public void function send( required string to,
                             required string subject,
                             string body = "",
                             struct argumentStruct = {},
                             string type = "html",
                             string toName = "",
                             string from = NO_REPLY_EMAIL,
                             string fromName = "",
                             string htmlPath = "",
                             string textPath = "",
                             string cc = "",
                             string bcc = "" ) {
    var emailStruct = arguments.argumentStruct;
    var isGmail = false;
    if ( findNoCase( "gmail", arguments.to ) || findNoCase( "gmail", arguments.cc ) || findNoCase( "gmail", arguments.bcc ) )
      isGmail = true;
    var hasHtml = false;
    var hasText = false;
    var htmlOnly = false;
    var textOnly = false;
    if ( findNoCase( "html", arguments.type ) )
      hasHtml = true;
    if ( findNoCase( "text", arguments.type ) )
      hasText = true;
    if ( hasHtml && !hasText )
      htmlOnly = true;
    if ( hasText && !hasHtml )
      textOnly = true;

    if ( structKeyExists( arguments, "toName" ) && len( arguments.toName ) )
      arguments.to = arguments.toName & " <" & arguments.to & ">";

    if ( structKeyExists( arguments, "fromName" ) && len( arguments.fromName ) )
      arguments.from = arguments.fromName & " <" & arguments.from & ">";

    var mailService = newMail();
    mailService.setSubject( arguments.subject );
    mailService.setTo( arguments.to );
    mailService.setFrom( arguments.from );
    if (htmlOnly)
      mailService.setType("html");
    if (textOnly)
      mailService.setType("text");
    mailService.setCharset("utf-8");
    if ( len( arguments.cc ) )
      mailService.setCc( arguments.cc );
    if ( len( arguments.bcc ) )
      mailService.setBcc( arguments.bcc );
    if ( len( arguments.body ) ) {
      mailService.setBody( arguments.body );
    } else {
      saveContent variable="emailBody" {
        include arguments.htmlPath;
      }
      mailService.setBody( emailbody );
    }
    mailService.send();
  }

  /**
   * Helper function to pass a debug struct in with optional subject to dump it out to the debug email recipient.
   *
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
  public void function sendDebugEmail( struct argumentStruct = {},
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
                                       string bcc = "" ) {
    send( argumentCollection = arguments );
  }

  /**
   * Returns the email domain from an email. It does not do
   * any validation on the email itself.
   *
   * @return the string after the "@" symbol in email.
   */
  public string function getEmailDomain( required string email ) {
    var emailLength = len( arguments.email );
    var atIndex = find( "@", arguments.email );
    if ( atIndex > 0 && atIndex < emailLength ) {
      return right( arguments.email, emailLength - atIndex );
    } else {
      return "";
    }
  }

  /**
   * Returns the email username from an email. It does not do
   * any validation on the email itself.
   *
   * @return the string before the "@" symbol in email.
   */
  public string function getEmailUsername( required string email ) {
    var emailLength = len( arguments.email );
    var atIndex = find( "@", arguments.email );
    if ( atIndex > 0 && atIndex < emailLength ) {
      return left( arguments.email, atIndex - 1 );
    } else {
      return "";
    }
  }

  /**
   * Helper function to create a new mail service with
   * the settings applied.
   */
  private any function newMail() {
    var mailService = new mail();
    if ( len( SMTP_SERVER ) ) {
      mailService.setServer( SMTP_SERVER );
      mailService.setPort( SMTP_PORT );
      mailService.setUseSSL( SMTP_SSL );
      mailService.setUsername( SMTP_USERNAME );
      mailService.setPassword( SMTP_PASSWORD );
    }
    return mailService;
  }
}