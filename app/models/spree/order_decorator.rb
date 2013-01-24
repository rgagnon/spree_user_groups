module Spree
  Order.class_eval do
    def user_group_adjustments
      adjustments.where(:originator_type => "Spree::UserGroup")
    end

    # ensure update_prices_per_user is called
    # after every associate_user call
    #
    # alias_method :associate_user_without_user_price!, :associate_user!

    def associate_user!(user)
      # associate_user_without_user_price! user

      # Alias method is causing stack level too deep, so for now just
      # copying over rest of method from Spree Core

      self.user = user
      self.email = user.email
      # disable validations since they can cause issues when associating
      # an incomplete address during the address step
      save(:validate => false)
      # --- End of copied from orig class definition ---#

      update_prices_per_user
    end


    # ensure update_prices_per_user is called
    # after every add_varaint call
    #
     alias_method :add_variant_without_user_price, :add_variant

    def add_variant(variant, quantity = 1, currency = nil)
      # current_item = add_variant_without_user_price(variant, quantity, currency)

      # Alias method is causing stack level too deep, so for now just
      # copying over rest of method from Spree Core
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
      current_item
      # --- End of copied from orig class definition ---#

      if update_prices_per_user
        current_item.reload
      else
        current_item
      end
    end


    # changes line_item price value if user has a group discount
    #
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
