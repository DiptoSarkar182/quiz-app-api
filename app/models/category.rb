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

  def self.show_category(category_id)
    category = Category.find_by(id: category_id)

    if category
      { status: :ok, data: category}
    else
      { status: :not_found, message: "Category not found" }
    end
  end

  def self.update_category(update_category_params)
    category = Category.find_by(id: update_category_params[:category_id])
    return { status: :not_found, message: "Category not found!" } unless category

    if category.update(update_category_params.except(:category_id))
      { status: :ok, message: "Category updated successfully", data: category }
    else
      { status: :unprocessable_entity, message: "Failed to update category", errors: category.errors.full_messages }
    end
  end

  def self.delete_category(category_id)
    category = Category.find_by(id: category_id)
    return { status: :not_found, message: "Category not found!" } unless category

    if category.destroy
      { status: :ok, message: "Category deleted successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to delete category", errors: category.errors.full_messages }
    end
  end

end
