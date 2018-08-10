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

    user.ideas.create name: idea_trimmed_string

    notify_new_idea
  end

  def start(*)
    if User.exists?(username: user.username)
      puts %(user #{user.username} tried triggering /start again)
      respond_with :message, text: "You're already a member, welcome back 👋! Here is a little refresher..."
      respond_with :message, text: instructions
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
    if Charge.where(email: telegram_email).exists?
      respond_with :message, text: welcome_message
      join_group!
      announce_new_group_member
    else
      respond_with :message, text: "Try again, must match email used for payment"
    end
  end

  def join_group!(*)
      respond_with :message, text: "Get Started in the our community 👋", reply_markup: {
      inline_keyboard: [
        [{text: "Join Idea Dojo group", url: ENV.fetch('TELEGRAM_GROUP_LINK')}],
      ],
    }
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
    if photo?
      create_photo_idea
      notify_new_idea
    end
  end

  # notfiies group of a new idea
  def notify_new_idea
    previous_idea_at = last_idea_at

    if previous_idea_at
      bot.send_message(
        chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
        text: %(💡 @#{user.username} shared a new idea! Previous idea was #{time_ago_in_words(previous_idea_at)} ago)
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

  def link(*)
    respond_with :message, text: user_url(user, host: ENV.fetch("HOST"))
  end

  def botstats(*)
    respond_with :message, text: "#{User.count} users, #{Idea.count} ideas."
  end

  def ideas(*)
    lines = user.ideas.order(created_at: :desc).collect do |idea|
      "#{time_ago_in_words idea.created_at} ago – #{idea.name || "(no description)"}"
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

  def photo_url
    photo = payload["photo"].sort_by { |p| p["file_size"] }.last
    file_path = bot.get_file(file_id: photo["file_id"])["result"]["file_path"]

    base = "https://api.telegram.org/file/bot"

    "#{base}#{ENV.fetch("TELEGRAM_BOT_TOKEN")}/#{file_path}"
  end

  def instructions
    %(Type /ideas to see all the ideas you've eaten.
Type /link to get a secret link to your private profile
Type /instructions if you need a refresher on commands
      )
  end

  def welcome_message
    %(👋 Welcome to the #@@app_name. You're now signed up!

Create a new idea by either snapping a picture and sending it to me, or use the /idea command to add a new idea without a photo. Go ahead, give it a try...
)
  end
end
