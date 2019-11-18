class ApplicationController < ActionController::API

    def normalize(string)
        string.gsub(/ +/, " ").gsub(/\&/, "and").parameterize.unicode_normalize
    end

    def render_errors(errors, status = 422)
        render json: { errors: errors }, status: status
    end

    def render_success(messages, status = 200)
        render json: { messages: messages }, status: status
    end

    def render_entities(entities)
        render json: entities, status: 200
    end

    def render_entity(entity)
        render json: entity, status: 200
    end

    def save_and_render(entity)
        if entity.save
            yield(entity) if block_given?
            render json: entity, status: 201
        else
            render_errors(entity.errors.full_messages)
        end
    end

    def update_and_render(entity, params)
        if entity.update params
            render json: entity, status: 200
        else
            render_errors(entity.errors.full_messages)
        end
    end

    def destroy_and_render(entity)
        entity.destroy
        render json: entity, status: 200
    end

    def current_user
        User.find_by(id: session[:user_id])
    end

    def group_entities(entities, column_name)
        # returns:
        # {
        #   column_value1: [entity1, entity3],
        #   column_value2: [entity2]
        # }
        entities.inject({}) do |acc, entity| 
            acc[entity.send(column_name)] ||= []
            acc[entity.send(column_name)] << entity
            acc
        end
    end
    
end
