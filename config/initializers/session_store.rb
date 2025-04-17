# Rails.application.config.session_store :cookie_store,
#   key: "_legal_project_session",
#   same_site: :none,
#   secure: Rails.env.production? || Rails.env.development?


Rails.application.config.session_store :cookie_store, key: '_legal_project_session'