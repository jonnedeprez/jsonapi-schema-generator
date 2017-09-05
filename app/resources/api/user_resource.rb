class Api::UserResource < Api::BaseResource
  attributes :name, :username, :password, :admin

  has_many :contracts

  def fetchable_fields
    super - [:password]
  end

  def self.updatable_fields(context)
    context[:user].admin? ? super : super - [:admin]
  end

end