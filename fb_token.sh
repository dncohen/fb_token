#!/bin/sh 


echo -en "Paste either your Facebook application ID (step 1), or paste the URL copied from previous step (that would be step 2): "
read X
echo $X | grep "[^0-9]" > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
  # If the grep found something other than 0-9
  # then it's not an integer.
    Y=$X
    
else
    echo $X
    
    # The grep found only 0-9, so it's an integer. 
    url="https://www.facebook.com/dialog/oauth?client_id=$X&scope=manage_pages,publish_stream&response_type=token&redirect_uri=https://www.facebook.com/connect/login_success.html"

    echo -en "Opening a web browser.  Please authorize your application in the browser.  When your browser says \"Success\" please copy and paste the browser's URL."
    
    if [ -n "$BROWSER" ]; then
        $BROWSER $url
    elif which xdg-open > /dev/null; then
        xdg-open $url
    elif which gnome-open > /dev/null; then
        gnome-open $url
    # elif bla bla bla...
    else
        echo "Could not detect the web browser to use.  Manually open a browser to this URL: $url"
    fi

    # It would be nice if the browser ran in the background and allowed user to paste value here.  But on my system the script exits when the browser is launched.
    echo -en "Now paste the URL shown in your browser: "
    read Y
fi

echo "  url: $Y"

# This should parse just the access token from the facebook.com URL.
token="$(echo $Y | sed -e's,.*access_token=\(.*\)&.*,\1,g')"

echo "  token: $token"

app_json=$(curl "https://graph.facebook.com/app?access_token=$token")

echo "  app $app_json"

id=$(echo "$app_json" | grep -Po '(?<="id":")[^"]*')
name=$(echo "$app_json" | grep -Po '(?<="name":")[^"]*')

if [ -n "$name" ]; then
    echo "Generating long-lasting tokens via application $name."
else
    echo "Could not use token $token. \n$app_json \n\n"
    exit 1
fi


echo "\nNext, we need your application's secret.  (hint see https://developers.facebook.com/apps/$id)"
echo -en "Please paste secret here: "

read secret

exchange=$(curl "https://graph.facebook.com/oauth/access_token?client_id=$id&client_secret=$secret&grant_type=fb_exchange_token&fb_exchange_token=$token")
echo "  exchange got: $exchange"

lt=$(echo $exchange | grep -Po '(?<=access_token=)[^&]*')

if [ -n "$lt" ]; then
    echo "Your personal long-lasting token is $lt"
else
    echo "Failed to get long-lasting token."
    echo "$exchange"
    exit 1
fi

accounts=$(curl "https://graph.facebook.com/me/accounts?access_token=$lt")
#echo "  accounts: $accounts"

tokens=$(echo $accounts | grep -Po '"name":"[^"]*","access_token":"[^"]*"')

if [ -n "$tokens" ]; then
    echo "Here are page-specific tokens you may choose.  Copy the access token without quotations.\n"
    echo "$tokens"
fi


