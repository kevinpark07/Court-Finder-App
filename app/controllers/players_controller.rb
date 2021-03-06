class PlayersController < ApplicationController
    skip_before_action :authorized, only: [:new,  :create]
    before_action :find_player, only: [:show, :edit, :update, :destroy, :profile]

    def index  
        # byebug
        @current_player = Player.find(session[:player_id]) 
        if params[:distance] && params[:distance] == "1 Mile"
            @players =  @current_player.nearbys(1)
        elsif params[:distance] && params[:distance] == "5 Miles"
            @players = @current_player.nearbys(5)
        elsif params[:distance] && params[:distance] == "10 Miles"
            @players = @current_player.nearbys(10)
        elsif params[:player_level]
            player_level = params[:player_level]
            @players = Player.player_level(player_level)
        else
            @players = Player.all
        end   
    end

    def show
        #@player = Player.find(@current_player)
        # @player = Player.find(params[:id])
    end

    def profile
        # @current_player = Player.find(session[:player_id])
    end

    def new
        @player = Player.new
    end

    def create
        @player = Player.create(player_params)
        #byebug
            if @player.valid?
                session[:player_id] = @player.id
                redirect_to profile_path(@player)
            else
                flash[:errors] = @player.errors.full_messages
                redirect_to new_player_path
            end
    end

    def edit
        # @player = Player.find(params[:id])
    end

    def update
        # @player = Player.find(params[:id])
        if @player.update(player_params)
            redirect_to profile_path(@player)
        else
            flash[:errors] = @player.errors.full_messages
            redirect_to edit_player_path(@player) ###where to direct??
        end
    end

    def destroy
        @player.destroy
        session.delete(:player_id)
        redirect_to "/"
    end

    private

    def player_params
        params.require(:player).permit(:name, :age, :level, :username, :password, :profile_picture, :address, :latitude, :longitude, :email, :about)
    end

    def find_player
        @player = Player.find(params[:id])
    end
    
end
