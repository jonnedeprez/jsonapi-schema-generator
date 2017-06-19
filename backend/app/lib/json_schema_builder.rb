class JsonSchemaBuilder

  # Possible requests and their responses                          content sent         content returned

  # show GET 200 include array in response                                              x
  # show GET 200 include resource in response                                           x
  # show GET 200 null_response                                                          x (only rare cases)
  # show GET 404 Not found
  # show GET 400 Error                                                                  x
  # show GET 500 Error                                                                  x
  #
  # create POST 201 Created include record in response             x                    x
  # create POST 204 Created with not response                      x
  # create POST 403 Forbidden                                      x                    ?
  # create POST 400 Error                                          x                    x
  # craete POST 500 Error                                          x                    x
  #
  # update PATCH/PUT 200 Updated include record in response        x                    x
  # update PATCH/PUT 204 Created with no response                  x
  # update PATCH/PUT 403 Forbidden                                 x                    ?
  # update PATCH/PUT 404 Not found                                 x
  # update PATCH/PUT 400 Error                                     x                    x
  # update PATCH/PUT 500 Error                                     x                    x
  #
  # delete DELETE 200 Accepted: Return meta data                                        x
  # delete DELETE 204 No Content
  # delete DELETE 403 Forbidden                                                         ?
  # delete DELETE 404 Not found
  # delete DELETE 400 Error                                                             x
  # delete DELETE 500 Error                                                             x

  def initialize(action, type, status_code=200)

    @action = action

    raise Exception.new('Unknown request type') unless [:response, :request].include? type

    @type = type
    @status_code = status_code

    if (action === :show || action === :delete) && type === :request
      raise Exception.new('GET and DELETE have no request payload')
    end

    if type === :response && (204 === status_code)
      raise Exception.new('A request with status code 204 has no response payload')
    end

    @json = {
        '$schema': 'http://json-schema.org/draft-04/schema#',
        type: 'object',
        required: %w(data),
        properties: {
            data: {},
            links: {
                allOf: [ { '$ref': "#/definitions/links" } ]
            },
            jsonapi: { '$ref': "#/definitions/jsonapi" }
        },
        definitions: {
            links: {
                type: "object",
                properties: {
                    self: { type: "string", format: "uri" },
                    related: { '$ref': "#/definitions/link" }
                },
                additionalProperties: true
            },
            link: {
                oneOf: [
                    { type: "string", format: "uri" },
                    {
                        type: "object",
                        required: [ "href" ],
                        properties: {
                            href: { type: "string", format: "uri" },
                            meta: { '$ref': "#/definitions/meta" }
                        }
                    }
                ]
            },
            meta: {
                type: 'object',
                additionalProperties: true
            },
            jsonapi: {
                type: 'object',
                properties: {
                    version: { type: 'string'},
                    meta: { '$ref': "#/definitions/meta" }
                },
                additionalProperties: false
            }
        },
        additionalProperties: false
    }

    self
  end

  def with_title(title)
    @json[:title] = title
    self
  end

  def with_description(description)
    @json[:description] = description
    self
  end

  def for_entity(entity)
    @entity = entity

    if @type === :response
      if @action === :get_collection
        reference = define_resource(entity, true)
        @json[:properties][:data] = {
            oneOf: [{
                        type: 'array',
                        items: { '$ref': reference },
                        uniqueItems: true
                    }]
        }
      else
        if [:get_single, :create, :update].include? @action
          reference = define_resource(entity, true)
          @json[:properties][:data] = {
              oneOf: [ { '$ref': reference } ]
          }
        end
      end
    else
      if [:create, :update].include? @action
        reference = define_resource(entity, @action === :update)
        @json[:properties][:data] = {
            oneOf: [ { '$ref': reference } ]
        }
      end
    end

    self
  end

  def with_included_entities(entities)
    @included_models = entities
    define_any_resource
    @json[:properties][:included] = {
        type: 'array',
        items: { '$ref': "#/definitions/any_resource" },
        uniqueItems: true
    }

    self
  end

  def with_related_entities(entities)
    @related_entities = entities
    self
  end

  def with_pagination_info
    @json[:properties][:links][:allOf] << { '$ref': "#/definitions/pagination" }
    @json[:definitions][:pagination] = {
        type: "object",
        properties: {
            first: {
                oneOf: [ { type: "string", format: "uri" }, { type: "null" } ]
            },
            last: {
                oneOf: [ { type: "string", format: "uri" }, { type: "null" } ]
            },
            prev: {
                oneOf: [ { type: "string", format: "uri" }, { type: "null" } ]
            },
            next: {
                oneOf: [ { type: "string", format: "uri" }, { type: "null" } ]
            }
        }
    }
    self
  end

  def json
    @json
  end

  protected

  def define_resource(entity, require_id)
    reference = "#{require_id ? 'existing' : 'new'}_#{entity.name.underscore}_resource"

    relationships_reference = define_resource_relationships(entity)

    # define_any_relationships

    attributes_reference = define_resource_attributes(entity)

    @json[:definitions][reference] =  {
        type: 'object',
        required: require_id ? %w(type id) : %w(type),
        properties: {
            type: { type: 'string'},
            id: { type: 'string'},
            attributes: { '$ref': attributes_reference },
            relationships: { '$ref': relationships_reference },
            links: { '$ref': "#/definitions/links" },
            meta: { '$ref': "#/definitions/meta" }
        },
        additionalProperties: false
    }

    "#/definitions/#{reference}"
  end

  def define_any_resource
    define_any_attributes
    define_any_relationships
    @json[:definitions][:any_resource] ||= {
        type: 'object',
        required: %w(type id),
        properties: {
            type: { type: 'string'},
            id: { type: 'string'},
            attributes: { '$ref': "#/definitions/any_attributes" },
            relationships: { '$ref': "#/definitions/any_relationships" },
            links: { '$ref': "#/definitions/links" },
            meta: { '$ref': "#/definitions/meta" }
        },
        additionalProperties: false
    }
  end

  def define_resource_attributes(entity)
    reference = entity.name.underscore + '_attributes'
    @json[:definitions][reference] ||= {
        type: 'object',
        properties: Hash[entity.fields.map {|f| [f.name, {type: f.field_type}]}],
        required: entity.fields.required.map {|f| f.name},
        additionalProperties: false
    }

    "#/definitions/#{reference}"
  end

  def define_resource_relationships(entity)
    reference = entity.name.underscore + '_relationships'



    properties = entity.relationships.map do |r|

      if r.cardinality === 'HAS_MANY'
        define_relationship_to_many
      else
        define_relationship_to_one
      end

      [r.hyphenized_name, {
          type: "object",
          properties: {
              links: { '$ref': "#/definitions/links" },
              data: {
                  '$ref': "#/definitions/relationship_to_#{r.cardinality === 'HAS_MANY' ? 'many' : 'one'}"
              },
              meta: { '$ref': "#/definitions/meta" }
          },
          additionalProperties: false
      }]
    end


    @json[:definitions][reference] ||= {
        type: 'object',
        properties: Hash[properties],
        required: entity.relationships.required.map {|r| r.hyphenized_name},
        additionalProperties: false
    }

    "#/definitions/#{reference}"
  end

  def define_any_attributes
      @json[:definitions][:any_attributes] ||= {
          type: 'object',
          patternProperties: {
              '^(?!relationships$|links$)\\w[-\\w_]*$': {
                  description: 'Attributes may contain any valid JSON value.'
              }
          },
          additionalProperties: false
      }
  end

  def define_any_relationships
    define_relationship_to_one
    define_relationship_to_many
    @json[:definitions][:any_relationships] ||= {
        type: 'object',
        patternProperties: {
            '^\\w[-\\w_]*$': {
                properties: {
                    links: { '$ref': "#/definitions/links" },
                    data: {
                        oneOf: [
                            { '$ref': "#/definitions/relationship_to_one" },
                            { '$ref': "#/definitions/relationship_to_many" }
                        ]
                    },
                    meta: { '$ref': "#/definitions/meta" }
                },
                additionalProperties: false
            }
        },
        additionalProperties: false
    }
  end

  def define_relationship_to_one
    define_empty
    define_linkage
    @json[:definitions][:relationship_to_one] ||= {
        anyOf: [
            { '$ref': "#/definitions/empty" },
            { '$ref': "#/definitions/linkage" }
        ]
    }
  end

  def define_relationship_to_many
    define_linkage
    @json[:definitions][:relationship_to_many] ||= {
        type: 'array',
        items: { '$ref': "#/definitions/linkage" },
        uniqueItems: true
    }
  end

  def define_linkage
    @json[:definitions][:linkage] ||= {
        type: 'object',
        required: %w(type id),
        properties: {
            type: { type: 'string'},
            id: { type: 'string'},
            meta: { '$ref': "#/definitions/meta" }
        },
        additionalProperties: false
    }
  end

  def define_empty
    @json[:definitions][:empty] ||= { type: 'null' }
  end

end