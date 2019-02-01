class DomainPrefixController < ApplicationController
  before_action :check_logged_in,only:[:domain_form]
  def domain_form # :nodoc:
  end

=begin
  **Author:** Vipul Kumar     
  **Common Name:** Function that creates entry in domain_prefixes table    
  **End points:** Other services     
  **Routes** : domain_prefix_create_domain_path     
  **Params:** 
              domain,type: string ,required: yes, DESCRIPTION-> 'Domain Name'  
              prefix,type: string,required: yes,  DESCRIPTION-> 'Prefix of Domain' 
  **Host:** localhost:3000    
=end
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
