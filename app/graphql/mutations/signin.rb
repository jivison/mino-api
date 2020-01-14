module Mutations
    class Signin < BaseMutation
        argument :username, String, required: true
        argument :password, String, required: true

        field :user, Types::UserType, null: false
        field :messages, [String], null: true

        def resolve(username:, password:)
            user = User.find_by(username: username)
            if user&.authenticate(password)
                context[:session][:user_id] = user.id
                return {user: user, messages: ["Successfully signed in"]}
            end
            return {user: User.new, messages: ["Username or password is incorrect"]}
        end
    end
end