fb_token
========

Facebook Access Token Generator

This script helps to get Facebook access tokens.  Especially when you need a long-lasting token allowing an application to access Facebook as a page.

To run this script, you'll need your application's ID number and also it's secret.  The application developer can learn these values on https://developers.facebook.com/apps.

The script will prompt you for the values it needs.  Supply the app id and the script will attempt to launch a browser.  Log into Facebook and authorize the app.  Then copy the URL shown in your browser and paste that entire string to the script.  Your access token will be part of that URL.  (You could optionally just paste the access token.)

The script will prompt you for the application's secret which is needed to exchange the short-lived token for a longer-lived one.

If the script succeeds, it will show you a long-lived token and a token for each of the pages your Facebook account has permission to manage.

These tokens can be used by <a href=//drupal.org/project/fb>Drupal for Facebook</a> or similar tools that prompt you for a token.

If you find this script useful, please consider <a href=//http://www.drupalforfacebook.org/contribute>making a donation to support this open-source software</a>.

TODO
====

TODO: make input more user friendly.
TODO: make output more user friendly.
TODO: make scope (permissions) configurable.
