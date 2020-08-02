require 'test_helper'

class ImageUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image_upload = image_uploads(:one)
  end

  test "should get index" do
    get image_uploads_url, as: :json
    assert_response :success
  end

  test "should create image_upload" do
    assert_difference('ImageUpload.count') do
      post image_uploads_url, params: { image_upload: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show image_upload" do
    get image_upload_url(@image_upload), as: :json
    assert_response :success
  end

  test "should update image_upload" do
    patch image_upload_url(@image_upload), params: { image_upload: {  } }, as: :json
    assert_response 200
  end

  test "should destroy image_upload" do
    assert_difference('ImageUpload.count', -1) do
      delete image_upload_url(@image_upload), as: :json
    end

    assert_response 204
  end
end
