class AdditionsController < ApplicationController
    before_action :find_addition, only: [:show, :destroy]

    def index
        render_entities(Addition.all)
    end

    def show
        render_entity(@addition)
    end

    def destroy
        destroy_and_render(@addition)
    end

    private
    def find_addition
        @addition = Addition.find(params[:id])
    end

end
