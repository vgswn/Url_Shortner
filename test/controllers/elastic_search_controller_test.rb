require 'test_helper'

class ElasticSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get elastic_search_search_url
    assert_response :success
  end

end
