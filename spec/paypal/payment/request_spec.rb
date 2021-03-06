require 'spec_helper.rb'

describe Paypal::Payment::Request do
  let :instant_request do
    Paypal::Payment::Request.new(
      :amount => 10,
      :currency_code => :JPY,
      :description => 'Instant Payment Request',
      :notify_url => 'http://merchant.example.com/notify',
      :items => [{
        :name => 'Item1',
        :description => 'Awesome Item!',
        :amount => 10
      }]
    )
  end

  let :recurring_request do
    Paypal::Payment::Request.new(
      :currency_code => :JPY,
      :billing_type => :RecurringPayments,
      :billing_agreement_description => 'Recurring Payment Request'
    )
  end

  describe '.new' do
    it 'should handle Instant Payment parameters' do
      instant_request.amount.should == 10
      instant_request.currency_code.should == :JPY
      instant_request.description.should == 'Instant Payment Request'
      instant_request.notify_url.should == 'http://merchant.example.com/notify'
    end

    it 'should handle Recurring Payment parameters' do
      recurring_request.currency_code.should == :JPY
      recurring_request.billing_type.should == :RecurringPayments
      recurring_request.billing_agreement_description.should == 'Recurring Payment Request'
    end
  end

  describe '#to_params' do
    it 'should handle Instant Payment parameters' do
      instant_request.to_params.should == {
        :PAYMENTREQUEST_0_AMT => "10.00",
        :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
        :PAYMENTREQUEST_0_DESC => "Instant Payment Request", 
        :PAYMENTREQUEST_0_NOTIFYURL => "http://merchant.example.com/notify",
        :L_PAYMENTREQUEST_0_NAME0 => "Item1",
        :L_PAYMENTREQUEST_0_DESC0 => "Awesome Item!",
        :L_PAYMENTREQUEST_0_AMT0 => "10.00"
      }
    end

    it 'should handle Recurring Payment parameters' do
      recurring_request.to_params.should == {
        :PAYMENTREQUEST_0_AMT => "0.00",
        :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
        :L_BILLINGTYPE0 => :RecurringPayments,
        :L_BILLINGAGREEMENTDESCRIPTION0 => "Recurring Payment Request"
      }
    end
  end
end