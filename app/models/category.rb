class Category < ApplicationRecord

  has_many :sub_categories, dependent: :destroy

  def self.all_categories
    Category.all
  end

  def self.create_category(category_params)
    category = Category.new(category_params)
    if category.save
      { status: :ok, message: "Category created successfully", data: category }
    else
      { status: :unprocessable_entity, message: "Failed to create category", errors: category.errors.full_messages }
    end
  end

end
