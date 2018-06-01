# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers

  Rails.application.routes.default_url_options[:host] = ENV.fetch("HOST")

  def start(*)
    respond_with :message, text: welcome_message
  end

  def message(*)
    return unless photo?

    previous_idea_at = last_idea_at
    create_idea

    status = if previous_idea_at
               "previous idea was #{time_ago_in_words(previous_idea_at)} ago"
             else
               "Your first logged idea. Yay!"
             end

    respond_with :message, text: "Your idea was logged! (#{status})"
  end

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

  def reminders(*)
    user.toggle_reminders

    text = if user.reminders_enabled?
             "🚨 Reminders are turned on. Type /reminders to turn them off."
           else
             "😶 Reminders are turned off. Type /reminders to turn them on."
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

  def create_idea
    user.ideas.create name: payload["caption"],
                      image_remote_url: photo_url,
                      created_at: payload_timestamp
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
    %(👋 Hi, welcome to the idea machine. Here's how it works:

Everytime you have an idea, snap a picture and send it to me.
Make sure to send it as a photo and not a file.
You can add a caption to the photo if you'd like.

Type /ideas to see all the ideas you've eaten.
Type /link to get a secret link to your private profile

You can turn on /reminders to get notified when you haven't uploaded an idea in a while.
Type /reminders to toggle your reminders on/off.

Happy ideation! 💡
)
  end
end
