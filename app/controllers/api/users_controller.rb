class Api::UsersController < Api::JSONAPIBaseController

  before_action :authenticate_request!

end
