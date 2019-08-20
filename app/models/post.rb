class Post < ApplicationRecord
  belongs_to :user
  has_many :comments


  has_many_attached :images
  validates :description, presence:true
  validate :images_type


  private
  def images_type
    if images.attached? == false
      errors.add(:images," are missing")
    end
    images.each do |image|
      if !image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:images," needs to be JPEG or PNG")
      end
    end
  end

end
