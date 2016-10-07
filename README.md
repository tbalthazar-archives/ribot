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
$ git clone xxx
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
