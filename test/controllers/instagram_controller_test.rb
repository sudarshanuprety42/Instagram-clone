require 'test_helper'

class InstagramControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instagram_index_url
    assert_response :success
  end

end
