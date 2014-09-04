class CancellationsController < ApplicationController

	before_filter :load_store

	def new
		@cancellation = @store.cancellations.build		
	end

	def create		
		@cancellation =  @store.cancellations.create(cancellation_params)		
		@cancellation.user = current_user
		@cancellation.stripe_customer_id = @store.stripe_customer_id
		@cancellation.plan_id = @store.plan_id

		#cancel stripe plan here
		customer = Stripe::Customer.retrieve(@store.stripe_customer_id)
		subscription = customer.subscriptions.first

		@store.plan_id = nil
		@store.save

		if !subscription.blank?
			subscription.delete
		end

		if @cancellation.save
			flash[:notice] = "your cancellation has been processed.  we're sorry to see you go."
		else
			messagearray = @cancellation.errors.full_messages
			flash[:warning] = messagearray
		end
	end


	private
    def load_store
      @store = Store.find(params[:store_id])
    end

    private 
	def cancellation_params
		params.require(:cancellation).permit(:store_id, :user_id, :reason)		
	end		


end
