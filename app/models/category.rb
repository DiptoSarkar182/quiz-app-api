class Category < ApplicationRecord

  has_many :sub_categories, dependent: :destroy

  def self.all_categories
    Category.all
  end
end
