# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers

  Rails.application.routes.default_url_options[:host] = ENV.fetch("HOST")

  @@app_name = "idea dojo"

  def idea(*)
    idea_payload = self.payload["text"]

    # removes the prepended /idea from the string
    idea_trimmed_string = idea_payload.split(' ')[1..-1].join(' ')

    if idea_trimmed_string.nil? || idea_trimmed_string.empty?
        respond_with :message, text: "Hmmm, doesn't seem like anything there..."
    else
      user.ideas.create name: idea_trimmed_string
      on_fire
      notify_new_idea
      unless payload["chat"]["type"] == "supergroup"
        respond_with :message, text: "You logged a new idea! Keep ideating 🧠..."
      end
    end
  end

  def start(*)
    if User.exists?(username: user.username)
      puts %(user #{user.username} tried triggering /start again)
      respond_with :message, text: "You're already a member, welcome back 👋! Here is a little refresher..."
      instructions
    else
      email_collection
    end
  end

  def email_collection(*)
    respond_with :message, text: %(
    Please provide your email address to get started.

Prepend with /email and make sure its the same as you used for payment.)
  end

  def email(*)
    telegram_email = payload['text'].split(' ')[1..-1].join(' ')
    user.update email: telegram_email
    #map this up against an array of stripe emails
    # if Charge.where(email: telegram_email).exists?
      respond_with :message, text: welcome_message
      instructions
      join_group!
      announce_new_group_member
    # else
    #   respond_with :message, text: "Try again, must match email used for payment"
    # end
  end

  def join_group!(*)
      respond_with :message, text: "When you're ready, add a brief description to your Telegram profile and get started in our community 👋.", reply_markup: {
      inline_keyboard: [
        [{text: "Join ThinkFish Group", url: ENV.fetch('TELEGRAM_GROUP_LINK')}],
      ],
    }
  end

  def instructions(*)
    instructions = %(
There are two ways I can log your idea!
1. Send a photo with a caption 📸
2. Type /idea followed by your idea text ✍️ (no photo)

I can also support you in a few ways...
1. /recent to see your 10 most recent ideas
2. /inspiration for a goodybag of ideas from the community
3. /library for the link to your web library of ideas
4. /instructions if you need a refresher on commands

...and shoot you numbers at any time!
1. /count to see how many ideas you've logged individually
2. /botstats to see how many ideas the community has logged

Happy ideation. Message @nicksarafa or @eli_ade with suggestions/feedback. Updates made regularly 😉.

      )
  respond_with :message, text: instructions
  end


  def announce_new_group_member(*)
    if User.exists?(username: user.username)
      Rails.logger.debug %(user #{user.username} tried announcing themselves again)
    else
      # Send the Telegram group an update stating the new member has joined
      bot.send_message(
        chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
        text: %(Welcome to #@@app_name, @#{user.username} 👋!)
      )
    end
  end

  def message(*)
    # checks if theres a photo, and creates an idea if there is
    if photo? && payload["caption"].present?
      create_photo_idea
      unless payload["chat"]["type"] == "supergroup"
        respond_with :message, text: "You logged a new idea! Keep ideating 🧠..."
      end
      notify_new_idea
    end
  end

  # notfiies group of a new idea
  def notify_new_idea
    previous_idea_at = last_idea_at

    if previous_idea_at
      bot.send_message(
        chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
        text: %(@#{user.username} logged an idea💡! Keep the wheels turning 🧠.)
      )
      else
        %(💡 @#{user.username} shared their first idea!)
    end
  end

  def create_photo_idea
    user.ideas.create name: payload["caption"],
                      image_remote_url: photo_url,
                      created_at: payload_timestamp
  end

  def library(*)
    respond_with :message, text: user_url(user, host: ENV.fetch("HOST"))
  end

  def botstats(*)
    respond_with :message, text: "#{User.count} users, #{Idea.count} ideas."
  end

  def count(*)
    respond_with :message, text: "You've logged #{user.ideas.count} ideas."
  end

  def inspiration(*)
    respond_with :message, text: "Ready, here come the goodies 🧚🏼‍♂️..."
    Idea.all.sample(3).each do |idea|
      respond_with :message, text: "#{idea.name}\n🎁 from @#{idea.user.username}"
    end
  end

  def recent(*)
    lines = user.ideas.order(created_at: :desc).first(10).collect do |idea|
      "#{idea.name}\nLogged #{time_ago_in_words idea.created_at} ago\n"
    end

    text = if lines.any?
             lines.join("\n")
           else
             "No ideas logged yet."
           end

    respond_with :message, text: text
  end

  rescue_from Telegram::Bot::Forbidden do
    # Forbidden: bot was blocked by the user
  end

  private

  def user
    user = User.where(telegram_id: payload["from"]["id"]).first_or_create
    user.update username: payload["from"]["username"]
    user
  end

  def last_idea_at
    user.ideas.maximum(:created_at)
  end

  def payload_timestamp
    Time.zone.at payload["date"]
  end

  # checks to make sure photo exists
  def photo?
    payload["photo"].present?
  end

  def on_fire
    case user.ideas.count
    when 10
      unless payload["chat"]["type"] == "supergroup"
        respond_with :message, text: "Strong start, you just logged your 10th idea 🚀🚀🚀!"
      end
      bot.send_message(
        chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
        text: %(@#{user.username} logged their 10th idea 🚀🚀🚀!)
      )
    when 50
      unless payload["chat"]["type"] == "supergroup"
        respond_with :message, text: "Look at you, just logged your 50th idea 🔥🔥🔥!"
      end
      bot.send_message(
        chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
        text: %(@#{user.username} logged their 50th idea 🔥🔥🔥!)
      )
    when 100
      unless payload["chat"]["type"] == "supergroup"
        respond_with :message, text: "Wow. You just logged your 100th idea 🤤🤤🤤!"
      end
      bot.send_message(
        chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
        text: %(@#{user.username} just logged their 100th idea 🤤🤤🤤!)
      )
    end
  end

  def photo_url
    photo = payload["photo"].sort_by { |p| p["file_size"] }.last
    file_path = bot.get_file(file_id: photo["file_id"])["result"]["file_path"]

    base = "https://api.telegram.org/file/bot"

    "#{base}#{ENV.fetch("TELEGRAM_BOT_TOKEN")}/#{file_path}"
  end

  def welcome_message
    %(👋 Welcome to ThinkFish. You're now signed up! Read the instructions below, take me for a quick spin, and join the community for the fun stuff.
)
  end
end
