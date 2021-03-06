# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "the hosted IOWP credit card online payment builder" do
  before(:each) do
    @node = Builder::XmlMarkup.new
  end
  it "should not build unknown keys" do
    @builder = GlobalCollect::Builders::InsertOrderWithPayment::HostedCreditCardOnlinePayment.new('foo' => 'bar')
    @builder.build(@node)
    xml = @node.target!
    
    xml.should have_xpath("/PAYMENT")
    xml.should_not have_xpath("/PAYMENT/foo")
  end

  it "should build hosted cc-specific keys" do
    fields = %w[
      EXPIRYDATE             
      CREDITCARDNUMBER       
      ISSUENUMBER            
      CVV                    
      CVVINDICATOR           
      AVSINDICATOR           
      AUTHENTICATIONINDICATOR
      STTINDICATOR           
      FIRSTNAME              
      PREFIXSURNAME          
      SURNAME                
      STREET                 
      HOUSENUMBER            
      CUSTOMERIPADDRESS      
      ADDITIONALADDRESSINFO  
      ZIP                    
      CITY                   
      STATE                  
      PHONENUMBER            
      EMAIL                  
      BIRTHDATE              
      DCCINDICATOR           
      ISSUERAMOUNT           
      ISSUERCURRENCYCODE     
      MARGINRATEPERCENTAGE   
      EXCHANGERATESOURCENAME 
      EXCHANGERATE           
      EXCHANGERATEVALIDTO    
      MAC                    
    ]
    @builder = GlobalCollect::Builders::InsertOrderWithPayment::HostedCreditCardOnlinePayment.new(
      fields.inject({}) {|m,k| m[k] = k; m }
    )
    @builder.build(@node)
    xml = @node.target!
    
    xml.should have_xpath("/PAYMENT")
    fields.each do |field|
      xml.should match_xpath("/PAYMENT/#{field}", field)
    end
  end
end
