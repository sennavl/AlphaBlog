require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest

	def setup
		@user = User.create(username: "johnDoe", email: "john@ex.com", password: "password", admin: true)
	end

	test "get new category form and create category" do
		sign_in_as(@user, "password")
		# go to the new category page (where a new category can be added via form)
		get new_category_path
		# check if the template matches
		assert_template 'categories/new'
		# add new category "sports" via post
		assert_difference 'Category.count', 1 do
			post categories_path, params: { category: {name: "sports"}}
			follow_redirect!
		end
		# where user is sent after the post
		assert_template 'categories/index'
		# index page of the categories should now contain the category "sports"
		assert_match "sports", response.body
	end

	test "invalid category submission results in failure" do
		sign_in_as(@user, "password")
		# go to the new category page (where a new category can be added via form)
		get new_category_path
		# check if the template matches
		assert_template 'categories/new'
		# add new category "sports" via post
		assert_no_difference 'Category.count' do
			post categories_path, params: { category: {name: " "}}
		end
		# where user is sent after the post
		assert_template 'categories/new'
		# check if these things are there
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end
end