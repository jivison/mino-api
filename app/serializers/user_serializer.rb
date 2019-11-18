class UserSerializer < ActiveModel::Serializer
  # localStorage is vulnerable to XSS attacks, so don't return any
  # sensitive information (like an email)
  # currentUser is stored in localStorage in the client
  attributes :id, :username
end
