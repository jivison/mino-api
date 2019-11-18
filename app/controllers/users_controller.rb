class UsersController < ApplicationController

    def create    
        user = User.new user_params
        save_and_render(user) do |saved_user|
            session[:user_id] = saved_user.id
        end
    end

    def current
        render_entity(current_user)
    end

    private
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username)
    end

end
