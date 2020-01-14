module Types
  class MutationType < Types::BaseObject
    field :signin, mutation: Mutations::Signin
  end
end
