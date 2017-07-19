class Api::ActionsController < Api::JSONAPIBaseController

  before_action :authenticate_request!

end

