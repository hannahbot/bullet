module Bullet
  module Notification
    class CounterCache < Base
      def body
        klazz_associations_str
      end

      def title
        markdown(("##")+("Need Counter Cache"))
      end
    end
  end
end
