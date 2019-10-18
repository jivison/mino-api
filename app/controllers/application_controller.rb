class ApplicationController < ActionController::API


    def save_and_render(entity)
        if entity.save
            render json: entity, status: 201
        else
            render json: {errors: entity.errors}, status: 422
        end
    end

    def update_and_render(entity, params)
        if entity.update params
            render json: entity, status: 200
        else
            render json: {errors: entity.errors}, status: 422
        end
    end

    def destroy_and_render(entity)
        entity.destroy
        render json: entity, status: 200
    end

end
