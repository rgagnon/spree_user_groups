module Spree
  Order.class_eval do

    def user_group_adjustments
      adjustments.where(:originator_type => "Spree::UserGroup")
    end

    def add_variant(variant, quantity = 1, currency = nil)
      current_item = find_line_item_by_variant(variant)
      if current_item
        current_item.quantity += quantity
        current_item.currency = currency unless currency.nil?
        current_item.save
      else
        current_item = LineItem.new(:quantity => quantity)
        current_item.variant = variant
        if currency
          current_item.currency = currency unless currency.nil?
          current_item.price    = variant.price_in(currency).amount
        else
          current_item.price    = variant.price
        end
        self.line_items << current_item
      end

      self.reload
      if update_prices_per_user
        current_item.reload
      else
        current_item
      end
    end

    # Associates the specified user with the order.
    def associate_user!(user)
      self.user = user
      self.email = user.email
      # disable validations since they can cause issues when associating
      # an incomplete address during the address step
      save(:validate => false)

      update_prices_per_user
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
