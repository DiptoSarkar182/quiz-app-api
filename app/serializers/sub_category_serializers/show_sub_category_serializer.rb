module SubCategorySerializers
  class ShowSubCategorySerializer
    include JSONAPI::Serializer

    attributes :id, :category_id, :category_title, :title, :created_at, :updated_at, :total_follower

    attribute :category_title do |sub_category|
      sub_category.category.title
    end
  end
end
