# cfboom Mail Services
This module contains a standard service to send emails.

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- https://github.com/joeltobey/cfboom-mail

##SYSTEM REQUIREMENTS
- Lucee 4.5+
- ColdFusion 9+

# INSTRUCTIONS
Just drop into your **modules** folder or use CommandBox to install

`box install cfboom-mail`

## WireBox Mappings
The module registers the EmailService: `EmailService@cfboomMail` that encapsulates basic email functionality. Check out the API Docs for all the possible functions.

## Settings
You'll need to set the default `debugEmail` and optionally the `noReplyEmail` in your `ColdBox.cfc` file under the `cfboomMail` struct of `moduleSettings`. Use the additional settings if you need:

```js
moduleSettings = {
  cfboomMail = {
    debugEmail = "your.email@mycompany.com",
    noReplyEmail = "no_reply@mycompany.com",
    server = "smtp.mycompany.com",
    port = 25,
    useSSL = false,
    username = "",
    password = ""
  }
};
```

## EmailService

Wirebox mapping `EmailService@cfboomMail`

```
var EmailService = getInstance( "EmailService@cfboomMail" );
var emailDomain = EmailService.getEmailDomain( emailAddress );

try {

  // do something

} catch ( any ex ) {

  // Send debug information now
  var debugStruct = {};
  debugStruct['ex'] = ex;
  debugStruct['info'] = myInfo;
  EmailService.sendDebugEmail( debugStruct, "Custom Error Subject" );

  ... additional catch logic

}
```
