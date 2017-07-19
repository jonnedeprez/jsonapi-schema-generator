class Api::EntitiesController < Api::JSONAPIBaseController

  before_action :authenticate_request!

end
