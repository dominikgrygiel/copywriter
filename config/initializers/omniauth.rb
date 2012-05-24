Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "303831603038231", "2cda762419a1b471b8538610ad29f65d"
end

