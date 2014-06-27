module Bullet
  module Notification
    class UnusedEagerLoading < Base
      def body
        markdown("#{klazz_associations_str}\n  Remove from your finder: #{associations_str}\n")
      end

      def title
        markdown(("##")+("Unused Eager Loading #{@path ? "in #{@path}" : 'detected'}"))
      end
    end
  end
end
