### Highlights
[telegram-bot-rb](https://github.com/telegram-bot-rb/telegram-bot)

---

### Installation

1. `git clone https://github.com/ChangeInit/idea-bot`

2. Create a Telegram bot using [@BotFather](https://t.me/botfather)

3. Setup your .env with the appropriate keys

4. `bundle install`

5. Configure your database in `config/database.yml`

6. Create the database `rails db:create`

7. On production `rails telegram:bot:set_webhook` to configure the webhook to
   communicate with Telegram. Or in development `rails telegram:bot:poller` to
configure the poller.

---

When things get weird run `rails db:reset`


### Configuration

[Shrine](https://shrinerb.com) used for simpler setup. You can do
this in [`config/initializers/shrine.rb`](config/initializers/shrine.rb).

### heroku production deployment

```
heroku run rake db:schema:load
heroku run rails telegram:bot:set_webhook
```



Heroku for hosting
AWS S3 for file hosting