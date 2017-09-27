class Api::JsonSpecController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :load_action

  before_action :cors_preflight_check
  after_action  :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS, PATCH'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

  def request_schema
    entity = @action.entity
    included_entities = @action.included_entities.to_ary
    action_name = params.require(:action_name)
    builder = JsonSchemaBuilder.new(@action.request_type.to_sym, :request)
                  .with_title("JSON API Schema for #{action_name} request body")
                  .for_entity(entity)
                  .with_included_entities(included_entities)

    render json: builder.json
  end

  def response_schema
    entity = @action.entity
    included_entities = @action.included_entities.to_ary
    status_code = params.require(:status_code).to_i
    action_name = params.require(:action_name)
    builder = JsonSchemaBuilder.new(@action.request_type.to_sym, :response, status_code)
                  .with_title("JSON API Schema for #{action_name}, status code #{status_code}")
                  .for_entity(entity)
                  .with_included_entities(included_entities)
                  # .with_description("url_regex: #{@action.url_regex}")
                  # .with_related_entities(included_entities)

    render json: builder.json
  end

  private

  def load_action
    c = Contract.find_by!(client: params.require(:client), server: params.require(:server))
    @action = Action.find_by! name: params.require(:action_name), contract_id: c.id
  end

  def record_not_found
    render json: {errors: {title: 'The requested resource could not be found'}}, status: 404
  end

end
