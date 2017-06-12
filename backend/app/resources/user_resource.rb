class UserResource < BaseResource
  attributes :name, :username, :password, :admin

  def fetchable_fields
    super - [:password]
  end

end