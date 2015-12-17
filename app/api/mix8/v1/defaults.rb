module Mix8
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        version 'v1'
        default_format :json
        format :json

        helpers do
          def authenticate!
            error!('Unauthorized. Invalid or expired token.', 401) unless current_user
          end

          def current_user
            user = User.find_by(remember_token: headers['Authorization'])
            if user
              @current_user = user
            else
              false
            end
          end
        end
      end
    end
  end
end