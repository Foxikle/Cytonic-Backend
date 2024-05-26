class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :confirmable, :rememberable, :timeoutable,
         :trackable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_one_attached :avatar

  has_many :forums_threads, :class_name => 'Forums::Thread', dependent: :nullify
  has_many :comments, :class_name => 'Comment', dependent: :nullify

  def moderator?
    Role.can_moderate.include? self.role
  end


  def jwt_payload
    super.merge('foo' => 'bar')
    super.merge email: email
  end
end
