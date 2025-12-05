require "test_helper"

class ProgressControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get progress_index_url
    assert_response :success
  end
end
