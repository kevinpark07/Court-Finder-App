    class SessionsController < ApplicationController

    def new

    end

    def login
        player = Player.find_by(username: params[:session][:username])
        if player && player.authenticate(params[:session][:password])
            session[:player_id] = player.id
            # byebug
            redirect_to player_path(player)
        else
            flash[:error] = "Username and/or Password Incorrect"
            redirect_to courts_path #login_path
        end
    end

    def logout 
        session.delete(:player_id)
        redirect_to '/'
    end

end
