module Spree
  class UserGroup < ActiveRecord::Base
    has_many :users, :dependent => :nullify
    validates :name, :presence => true

    attr_accessible :name, :calculator

    calculated_adjustments

    def calculator_description
      return t(:none) if calculator.nil?
      "#{I18n.t(:price)} - some percentage"
    end
  end
end
