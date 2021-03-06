require 'redcarpet'

module Bullet
  module Notification
    class Base
      attr_accessor :notifier, :url
      attr_reader :base_class, :associations, :path

      def initialize(base_class, association_or_associations, path = nil)
        @base_class = base_class
        @associations = association_or_associations.is_a?(Array) ?  association_or_associations : [association_or_associations]
        @path = path
      end

      def title
        raise NoMethodError.new("no method title defined")
      end

      def body
        raise NoMethodError.new("no method body defined")
      end

      def call_stack_messages
        ""
      end

      def whoami
        @user ||= ENV['USER'].presence || (`whoami`.chomp rescue "")
        if @user.present?
          "user: #{@user}"
        else
          ""
        end
      end

      def body_with_caller
        "#{body}\n#{call_stack_messages}\n"
      end

      def notify_inline
        self.notifier.inline_notify(notification_data)
      end

      def notify_out_of_channel
        self.notifier.out_of_channel_notify(notification_data)
      end

      def short_notice
        [whoami.presence, url, title, body].compact.join("  ")
      end

      def notification_data
        {
          :user => whoami,
          :url => url,
          :title => title,
          :body => body_with_caller,
        }
      end

      def eql?(other)
        klazz_associations_str == other.klazz_associations_str
      end

      def hash
        klazz_associations_str.hash
      end

      class HTMLwithPygments < Redcarpet::Render::HTML
        def block_code(code, language)
          Pygments.highlight(code, :lexer => language)
        end
      end

      def markdown(text)
        renderer = HTMLwithPygments.new(hard_wrap: true)
          options = {
          :no_intra_emphasis => true,
          :fenced_code_blocks => true
          }
        Redcarpet::Markdown.new(renderer, options).render(text).html_safe
      end

      protected
        def klazz_associations_str
          "  #{@base_class} => [#{@associations.map(&:inspect).join(', ')}]"
        end

        def associations_str
          ":includes => #{@associations.map{ |a| a.to_s.to_sym unless a.is_a? Hash }.inspect}"
        end
    end
  end
end
