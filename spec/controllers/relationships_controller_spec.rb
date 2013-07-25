require "spec_helper"

describe RelationshipsController do
	let(:user) { FactoryGirl.create(:user) } 
	let(:other_user) { FactoryGirl.create(:user) } 

	# Unit test to check ajax requests!
	# use no_capybara: true so that we can use the xhr method (XmlHttpRequest)

	before { sign_in user } 

	describe "creating a relationship with Ajax" do

		it "should increment the Relationship count" do
			expect do
				# xhr takes as arguments
				# symbol for HTTP method (:post here)
				# symbol for the action (:create here)
				# hash representing the contents of params in controller!
				xhr :post, :create, relationship: { followed_id: other_user.id }
			end.to change(Relationship, :count).by(1)			
		end

		it "should respond with success" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			expect(response).to be_success
		end
	end

	describe "destroying a relationship with Ajax" do
		before { user.follow!(other_user) } 
		let(:relationship) { user.relationships.find_by_followed_id(other_user.id) } 

		it "should decrement the Relationship count" do
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.to change(Relationship, :count).by(-1)		
		end

		it "should respond with success" do
			xhr :delete, :destroy, id: relationship.id
			expect(response).to be_success
		end
	end
end