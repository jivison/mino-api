module Types
  class MutationType < Types::BaseObject
    field :signin, mutation: Mutations::Signin
    field :signout, mutation: Mutations::Signout
    field :signup, mutation: Mutations::Signup
  end
end
