# RiBot

```
                _____
               /_____\
          ____[\`---'/]____
         /\ #\ \_____/ /# /\
        /  \# \_.---._/ #/  \
       /   /|\  |   |  /|\   \      RiBot - The Ruby API Reference Bot
      /___/ | | |   | | | \___\
      |  |  | | |---| | |  |  |     
      |__|  \_| |_#_| |_/  |__|     
      //\\  <\ _//^\\_ />  //\\     
      \||/  |\//// \\\\/|  \||/
            |   |   |   |           
            |---|   |---|
            |---|   |---|
            |   |   |   |
            |___|   |___|
            /   \   /   \
           |_____| |_____|
           |HHHHH| |HHHHH|
```

RiBot is a simple Slack bot that allows to ask for Ruby Core/Stdlib documentation.  
RiBot uses the [ri CLI tool](http://www.jstorimer.com/blogs/workingwithcode/7766081-5-reasons-you-should-use-ri-to-read-ruby-documentation) to provide documentation.

## Getting Started

**1. Create a new bot user in your Slack account:**

- Visit https://my.slack.com/apps/new/A0F7YS25R-bots
- Choose a username for your bot, e.g: `ribot`
- Take note of the API Token for this bot
- Click the Save Integration button

**2. Clone this repository:**

```bash
$ git clone git@github.com:tbalthazar/ribot.git
``` 

**3. Change directory to `ribot` and run the setup script:**

It will install the `ri` documentation for all your installed gems, it might take a while.

```bash
$ cd ribot
$ script/setup
``` 

**4. Run the ribot client:**

```bash
$ TOKEN=your-slack-api-token script/run
``` 

**5. Open Slack and type the following command:**

```bash
/msg @ribot help
``` 

## Usage

In the channels where the bot has been invited, type one of the following commands:
- `ri Array#sort`
- `@ribot Array#sort`
Or send the bot a direct message:
- `/msg @ribot Array#sort`

## Token

The bot needs a Slack API Token to work properly.
The `script/run` script will:
1. look for a `TOKEN` environment variable
2. if not found, it will try to read the token from the `.token` file
3. if no `.token` file exists, it will prompt for the token

## Tests

You can run the tests using:

```bash
$ script/test
```

## License

Please see [LICENSE](/LICENSE) for licensing details. 

## Remarks

### Gems

**Remark**: Slack offers an Event API and a RealTime Messaging (RTM) API. The RTM API uses websockets and do not require the machine running the bot to be able to receive external HTTP requests. This project needs to be able to run on a machine that is not publicly visible on the Internet (e.g: a laptop vs a server). This bot thus needs to use the RTM API.

**slack-ruby-client** is a Ruby client that talks to the Slack RealTime Messaging API. Since the idea of this project is to develop a bot and not a client for the Slack API, it made sense to me to use this gem. Its API is clean and my code only uses a few methods of it. Should this gem stop working, replacing it by another one do not require too much change in the RiBot code.

**EventMachine** and **faye-websocket** are dependencies for the **slack-ruby-client** gem.

**rake** is used to run all the tests. Rake is so common in Ruby projects and so useful that I don't consider it as a dependency, but as a good practice.

### Decisions

- I decided not to test the output of the `ri` command because it is an external dependency and it slows the tests. Instead, I test the bot will issue the correct command, with the expected arguments and flags.
- I decided to allow the user to talk to the bot is several ways: via direct messages, by mentioning it or by using the `ri` trigger command. That way, the bot accommodates to the user's preferences, not the other way around.
- I tried to make the bot as helpful as possible when handling errors, by replying with the expected usage of the bot and giving some context to the message (e.g: listing the channels which the bot is a member of)
- Bots should be fun and helpful. When the bot starts, it prints a picture of itself and a helpful message that explains how to use it for the first time.
