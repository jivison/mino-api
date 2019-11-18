class SessionController < ApplicationController

    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render_entity(user)
        else
            render_errors(["Username or password is incorrect"], 400)
        end
    end

    def destroy
        session[:user_id] = nil
        render_success("Signed out.")
    end

end
