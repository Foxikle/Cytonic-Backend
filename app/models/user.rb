class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :confirmable, :rememberable, :timeoutable,
         :trackable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  def jwt_payload
    super.merge('foo' => 'bar')
    super.merge email: email
  end
end
