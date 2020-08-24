# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy
unless Rails.env.test?

  Rails.application.config.content_security_policy do |policy|
    policy.default_src :self, :data, :blob, "fonts.gstatic.com", "*.crisp.chat", "crisp.chat", "*.crisp.help", 'https://*.tiles.mapbox.com', 'https://api.mapbox.com', 'https://events.mapbox.com'
    policy.font_src    :self, :data, 'fonts.gstatic.com', '*.bootstrapcdn.com', "*.crisp.chat", "crisp.chat"
    policy.img_src     :self, :data, :blob, '*.cloudinary.com', "*.openstreetmap.org", "stats.data.gouv.fr", "*.crisp.chat", "crisp.chat"
    policy.worker_src  :self, :blob
    policy.object_src  :none
    policy.style_src   :self, :unsafe_inline, 'fonts.googleapis.com', '*.bootstrapcdn.com', '*.mapbox.com', '*.mailchimp.com', "*.crisp.chat", "crisp.chat"
    if Rails.env.development?
      policy.script_src  :self, :unsafe_inline, "localhost:3000", "stats.data.gouv.fr", "*.crisp.chat", "crisp.chat", "*.mapbox.com"
      policy.connect_src :self, :https, 'http://localhost:3035', 'ws://localhost:3035', 'ws://localhost:3000', "wss://*.crisp.chat", "*.crisp.chat", 'https://*.tiles.mapbox.com', 'https://api.mapbox.com', 'https://events.mapbox.com'
    else
      policy.script_src  :self, :unsafe_inline, "stats.data.gouv.fr", "*.crisp.chat", "crisp.chat", "*.mapbox.com"
      policy.connect_src :self, "wss://*.crisp.chat", "*.crisp.chat", 'https://*.tiles.mapbox.com', 'https://api.mapbox.com', 'https://events.mapbox.com'
    end
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
