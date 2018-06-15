# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers

  Rails.application.routes.default_url_options[:host] = ENV.fetch("HOST")

  @app_name = "idea dojo"

  def start(*)
    if User.exists?(username: user.username)
      Rails.logger.debug %(user #{user.username} tried triggering /start again)
      respond_with :message, text: "You're already started! Welcome back 👋"
    else
      respond_with :message, text: welcome_message
      announce_new_group_member
    end
  end

  def announce_new_group_member(*)
    if User.exists?(username: user.username)
      Rails.logger.debug %(user #{user.username} tried announcing themselves again)
    else
      # Send the Telegram group an update stating the new member has joined
      bot.send_message(
        chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
        text: %(Welcome to #{@app_name}, @#{user.username} 👋!)
      )
    end
  end

  def message(*)
    return unless photo?

    previous_idea_at = last_idea_at
    create_idea

    if previous_idea_at
      bot.send_message(
        chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
        text: %(💡 @#{user.username} shared a new idea! Previous idea was #{time_ago_in_words(previous_idea_at)} ago)
      )
      else
        %(💡 @#{user.username} shared their first idea!)
    end
  end

  def create_idea
    user.ideas.create name: payload["caption"],
                      image_remote_url: photo_url,
                      created_at: payload_timestamp
    # share_new_idea
  end

  # shares new idea to the Telegram group
  # might scope into standalone method in the future to consolidate methods with messages sending
  # def share_new_idea
  #   bot.send_message(
  #     chat_id: ENV.fetch("TELEGRAM_GROUP_ID"),
  #     text: %(💡 @#{user.username} created a new idea! )
  #   )
  # end

  def last(*)
    respond_with :message, text: "Your last idea was #{time_ago_in_words(last_idea_at)} ago"
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

  def photo?
    payload["photo"].present?
  end

  def photo_url
    photo = payload["photo"].sort_by { |p| p["file_size"] }.last
    file_path = bot.get_file(file_id: photo["file_id"])["result"]["file_path"]

    base = "https://api.telegram.org/file/bot"

    "#{base}#{ENV.fetch("TELEGRAM_BOT_TOKEN")}/#{file_path}"
  end

  def welcome_message
    %(👋 Hi, welcome to the #{@app_name}. Here's how it works:

Everytime you have an idea, snap a picture and send it to me.
Make sure to send it as a photo and not a file.
You can add a caption to the photo if you'd like.

Type /ideas to see all the ideas you've eaten.
Type /link to get a secret link to your private profile

Happy ideation! 💡
)
  end
end
