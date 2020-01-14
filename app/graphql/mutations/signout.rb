module Mutations
    class Signout < BaseMutation
        field :messages, [String], null: false

        def resolve
            context[:session][:user_id] = nil
            {messages: ["Signed out successfully"]}
        end
    end
end
