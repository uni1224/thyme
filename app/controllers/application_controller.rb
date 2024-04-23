class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    add_flash_types :success, :info, :warning, :danger
    def after_sign_out_path_for(resource)
      about_path
    end

  protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name])
    end
end
