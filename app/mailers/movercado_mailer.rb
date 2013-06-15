class MovercadoMailer < ActionMailer::Base
 default from: "valter.paruque@gmail.com"
  
  def notify_suspicious_sales_amount(vendor)
  		vendor_id = vendor.id
  		mail(:to => "valter.paruque@gmail.com" , :subject => "Final movercado-analysis submission")
  end
end
