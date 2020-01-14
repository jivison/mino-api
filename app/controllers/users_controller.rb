class UsersController < ApplicationController

    def create    
        if params[:password] == params[:password_confirmation]
            user = User.new user_params
            save_and_render(user) do |saved_user|
                session[:user_id] = saved_user.id
            end
        else
            render_errors(["Passwords do not match"])
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
