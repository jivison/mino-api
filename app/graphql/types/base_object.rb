module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Types::BaseField

    # field :messages, [String], null: true
  end
end
