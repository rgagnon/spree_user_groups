module Spree
  BaseController.class_eval do

    include Spree::Core::ControllerHelpers::Order
    before_filter :ubiquitous_associate_user

    private
      # it is critical that we don't wait until the checkout process to
      # attach the user and the order, since we need the cart and
      # the order.total amounts to reflect the user-group-adjusted amounts
      def ubiquitous_associate_user
        @order = current_order
        associate_user
      end
  end
end
