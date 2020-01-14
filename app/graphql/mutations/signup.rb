module Mutations
    class Signup < BaseMutation
        argument :email, String, required: true
        argument :username, String, required: true
        argument :password, String, required: true
        argument :password_confirmation, String, required: true

        field :user, Types::UserType, null: true
        field :messages, [String], null: true

        def resolve(email:, username:, password:, password_confirmation:)
            messages = []
            user = User.new(email: email, username: username, password: password)
            if password == password_confirmation
                if user.save
                    messages = ["Signed up successfully!"]
                    context[:session][:user_id] = user.id
                    return {user: user, messages: messages}
                end
                messages << user.errors.full_messages
                messages.flatten!
            else
                messages << "Passwords do not match"
            end
            return {messages: messages}
        end
    end
end