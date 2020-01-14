module Types
  class UserType < Types::BaseObject
    field :username, String, null: false
    # field :password, String, null: false
    field :id, ID, null: false
  end
end
