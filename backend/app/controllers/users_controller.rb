class UsersController < JSONAPIBaseController

  before_action :authenticate_request!

end
