module SubCategoryQuizSerializers
  class QuizSerializer
    include JSONAPI::Serializer

    attributes :id, :sub_category_id, :quiz_question, :quiz_options

    attribute :sub_category_id do |quiz|
      quiz.sub_category.id
    end
  end
end
