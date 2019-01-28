require 'test_helper'

class DomainPrefixControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get domain_prefix_index_url
    assert_response :success
  end

end
