class SubCategory < ApplicationRecord

  belongs_to :category

  has_many :sub_category_followers, dependent: :destroy
  has_many :users, through: :sub_category_followers
  has_many :sub_category_leaderboards, dependent: :destroy
  has_many :sub_category_quizzes, dependent: :destroy
  has_many :challenge_friends, dependent: :destroy

  def self.sub_categories_for_category(category_id)
    category = Category.find_by(id: category_id)

    if category
      { status: :ok, data: category.sub_categories }
    else
      { status: :not_found, message: "Category not found" }
    end
  end

  def self.top_sub_categories_list
    where("total_follower > 0").order(total_follower: :desc).limit(10)
  end

  def self.create_sub_category(sub_category_params)
    unless Category.exists?(id: sub_category_params[:category_id])
      return { status: :not_found, message: "Category not found" }
    end

    sub_category = SubCategory.new(sub_category_params)

    if sub_category.save
      { status: :ok, message: "Sub category created successfully", data: sub_category }
    else
      { status: :unprocessable_entity, message: "Failed to create sub category", errors: sub_category.errors.full_messages }
    end
  end

  def self.show_sub_category(sub_category_id)
    sub_category = SubCategory.find_by(id: sub_category_id)

    if sub_category
      data = SubCategorySerializers::ShowSubCategorySerializer.new(sub_category).serializable_hash[:data][:attributes]
      { status: :ok, data: data }
    else
      render json: { message: "Sub category not found" }, status: :not_found
    end
  end

  def self.update_sub_category(update_sub_category_params)
    sub_category_id = update_sub_category_params[:sub_category_id]
    category_id = update_sub_category_params[:category_id]

    sub_category = SubCategory.find_by(id: sub_category_id)
    return { status: :not_found, message: "Sub category not found!" } if sub_category.nil?

    category = Category.find_by(id: category_id)
    return { status: :not_found, message: "Category not found!" } if category.nil?

    if sub_category.update(update_sub_category_params.except(:sub_category_id))
      { status: :ok, message: "Sub category updated successfully", data: sub_category }
    else
      { status: :unprocessable_entity, message: "Failed to update sub category", errors: sub_category.errors.full_messages }
    end
  end

  def self.delete_sub_category(sub_category_id)
    sub_category = SubCategory.find_by(id: sub_category_id)
    return { status: :not_found, message: "Sub category not found!" } unless sub_category

    if sub_category.destroy
      { status: :ok, message: "Sub category deleted successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to delete sub category", errors: sub_category.errors.full_messages }
    end
  end

end
