# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # POST /resource
    def create
      super do |resource|
        redirect_to after_sign_up_path_for(resource), status: :found and return if resource.persisted?
      end
    end
  end
end
