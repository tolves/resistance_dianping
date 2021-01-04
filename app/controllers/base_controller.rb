class BaseController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  rescue_from StandardError do |e|
    respond_with :message, text: e
  end

  use_session!

  I18n.locale = :zh


  module Methods

    def admin?
      !!Admin.find_by_chat_id(from['id'])
    end

    def tolves
      75708608
    end

    def user_name
      from['username'].blank? ? full_name : from['username']
    end

    def full_name
      "#{from['first_name']} #{from['last_name']}"
    end

    def pg_offset
      15
    end

    def session_destroy
      session.destroy
      puts "#{from['id']}: session has been cleaned"
    end

    def pagination(size, pg_offset = 15, **args)
      page_kb = []
      (1..((size - 1) / pg_offset) + 1).each do |p|
        next if p == (args[:page] + 1)

        page_kb.push({ text: p, callback_data: "#{args[:action]}:#{(p - 1)}" })
      end
      page_kb
    end

    def exit?
      return unless payload['text'] == 'exit'

      session_destroy
      raise t(:exit)
    end
  end

end