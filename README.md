# coti-node-monitor
Coti Node Monitor keeps your COTI node online by fixing common issues when the node goes offline.  This can happen for a variety of reasons like a chain unsync.
# UNDER CONSTRUCTION
Every approximately 15 minutes your node will run coti-node-monitor.sh script which will check your node and message you at telegbram when there is something that needs attention.

## Features
I will list all of the features here in the next version.
## Step 1: Create Telegram Bot Using Botfather

In order to message you on telegram, we will create a telegram bot which you control the bot token for.

#### The following steps describe how to create a new bot:

* Contact [**@BotFather**](https://telegram.me/BotFather) in your Telegram messenger.
* To get a bot token, send BotFather a message that says **`/newbot`**.
* When asked for a name for your new bot choose something that ends with the word bot, so for example YOUR_NODE_NAMEbot.
* If your chosen name is available, BotFather will then send you a token.
* Save this token as you will be asked for it once you execute the install-coti-node-monitor.sh script.

Once your bot is created, you can set a custom name, profile photo and description for it. The description is basically a message that explains what the bot can do.

#### To set the Bot name in BotFather do the following:

* Send **`/setname`** to BotFather.
* Select the bot which you want to change.
* Send the new name to BotFather.

#### To set a Profile photo for your bot in BotFather do the following:

* Send **`/setuserpic`** to BotFather.
* Select the bot that you want the profile photo changed on.
* Send the photo to BotFather.

#### To set Description for your bot in BotFather do the following:

* Send **`/setdescription`** to BotFather.
* Select the bot for which you are writing a description.
* Change the description and send it to BotFather.

For a full list of command type /help

## Step 2: Obtain Your Chat Identification Number

Visit my dedicated telegram bot here [**@StafiChatIDBot**](https://t.me/StafiChatIDBot) for collecting your Chat ID that you will be asked for when you run install-coti-node-monitor.sh in Step 3 that follows.

## Step 3: Download & Setup The Scripts Required For Stafi Stats

<br>

```
cd /home/coti/
mkdir -p "coti-node-monitor"
wget -O install-coti-node-monitor.sh https://raw.githubusercontent.com/Geordie-R/coti-node-monitor/master/install-coti-node-monitor.sh
sudo chmod +x install-coti-node-monitor.sh && ./install-coti-node-monitor.sh
```

You will be asked a series of questions.  Please type in your own answer to each question pressing enter after each one.  Once thats finished lets download the main stats.sh script below.

```
wget -O coti-node-monitor.sh https://raw.githubusercontent.com/Geordie-R/coti-node-monitor/master/coti-node-monitor.sh
sudo chmod +x coti-node-monitor.sh && chown $USER:$USER coti-node-monitor.sh
```
<br>

## Step 4: Test Telegram

Test that your telegram bot is setup correctly by running the following.

```
wget -O telegramtest.sh https://raw.githubusercontent.com/Geordie-R/stafi-stats/master/telegramtest.sh
sudo chmod +x telegramtest.sh && ./telegramtest.sh
```

Note: Anytime you want to run a telegram test in the future just run /home/coti/coti-node-monitor/telegramtest.sh

## Step 5: Test Coti Node Monitor

To test you could modify the chain index tolerance variable to 0 and send a testnet transaction to see if it thinks the chain is unsync. Make sure to put it back to 10 afterwards.

```
sudo nano /home/coti/coti-node-monitor/nodemonitor.properties
```

Once you have made the changes press Ctrl + X and then press Y to save.

Now just wait for the next 5 minute cycle.  You should be alerted. Or, if you want to run it manually to bypass the schedule run the following

```
/home/coti/coti-node-monitor/coti-node-monitor.sh
```

Thats it! Now amend the config back to reasonable values by repeating Step 5 and you're good to go.

## UPDATES --
To quickly get up to date if you currently use coti-node-monitor first log in to the user which runs your node like the coti user, then run the following: 
```
cd /home/coti/coti-node-monitor
rm coti-node-monitor.sh
wget -O coti-node-monitor.sh https://raw.githubusercontent.com/Geordie-R/coti-node-monitor/master/coti-node-monitor.sh
chmod +x coti-node-monitor.sh
```
