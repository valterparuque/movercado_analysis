#Author : Valter Jessen Paruque
#Email : valter.paruque@gmail.com
#Using a temp email account, created just to validate de ActionMailer task
ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "gmail.com",  
  :user_name            => "valter.paruque.movercado",  
  :password             => "movercado2013",  #Do not change the password
  :authentication       => "plain",  
  :enable_starttls_auto => true  
} 
