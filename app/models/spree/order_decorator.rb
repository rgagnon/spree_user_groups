module Spree
  # Placing these methods in module and calling super
  # because alias_method was causing stack too deep errors:
  # Bascially, methods were calling themselves recursively
  # when running specs
  module UserGroupPricing

    def new(*args)
      super.extend(UserGroupPricing)
    end

    # ensure update_prices_per_user is called
    # after every associate_user call
    def associate_user!(user)
      super
      update_prices_per_user
    end

    # ensure update_prices_per_user is called
    # after every add_varaint call
    def add_variant(variant, quantity = 1, currency = nil)
      current_item = super
      if update_prices_per_user
        current_item.reload
      else
        current_item
      end
    end

  end
  Order.class_eval do

    def user_group_adjustments
      adjustments.where(:originator_type => "Spree::UserGroup")
    end

    def update_prices_per_user
      return unless self.user.present?

      changes = false
      self.line_items.each do |line_item|
        user_price = line_item.variant.price_for_user(self.user)
        if user_price != line_item.price
          line_item.price = user_price
          line_item.save
          changes = true
        end
      end


      self.reload if changes
      changes
    end

  end
end

Spree::Order.extend(Spree::UserGroupPricing)
