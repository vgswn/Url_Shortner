class DomainPrefixController < ApplicationController
  def domain_form
  end

  def create_domain
  	params[:prefix]=params[:prefix] + '/'
  	if DomainPrefix.create_entry(domain_params)
  		flash[:status] = "Created !!"
      	redirect_to home_page_index_path
  	else
  		flash[:Error] = "Taken Try Again Either Domain or Prefix is taken"
      	redirect_to domain_prefix_domain_form_path
  	end
  end

  private
  def domain_params
    params.permit(:domain,:prefix)
  end
end
