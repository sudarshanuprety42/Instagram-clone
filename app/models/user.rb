class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :display_picture

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :followers, dependent: :destroy
  has_many :followings, dependent: :destroy

  validate :image_type

  # serialize :followers, Array
  # serialize :followings, Array

  private
  def image_type
    if display_picture.attached? == false
      errors.add(:display_picture," is missing")
    elsif !display_picture.content_type.in?(%('image/jpeg image/png'))
      errors.add(:display_picture," needs to be JPEG or PNG")
    end
  end
end
