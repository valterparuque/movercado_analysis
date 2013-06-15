class TrocaAkiValidation < App

MAX_MONTHLY_SALES_AMOUNT = 1000

#Verifiy current monthly sales amount for specific users and tell us if its suspicious or not
def hasNonSuspiciousMonthlySalesAmount(vendor_user)
    timeNow = Time.now    
    curentMonthlySales = Interaction.where(
                            :interactions =>{
                              :user_id => vendor_user.id , 
                              :created_at => timeNow.beginning_of_month..timeNow.end_of_month
                              },
                            :apps => {
                              :type => 'TrocaAkiValidation'})
                          .includes(:app).count 

    #puts "Current #{curentMonthlySales}"
    curentMonthlySales < MAX_MONTHLY_SALES_AMOUNT
  end  
  
  def process(sms)
    vendor_phone = sms.sender_phone

    unless user_code = sms.user_code
      Sms.push(vendor_phone, t("code.invalid")); return
    end

    unless user_code.times_used < 1
      Sms.push(vendor_phone, t("code.overuse")); return
    end

    sender = sms.sender

    unless sender.vendor?(self)      
      Sms.push(vendor_phone, "Sorry sender ID #{sender.id} you  are not a vendor"); return
    end

    
    #Retrive for current month the amount of sales       
    unless hasNonSuspiciousMonthlySalesAmount(vendor_phone.user)     
     puts "More than 1000 sales, its suspicious.....  aborting!"
     MovercadoMailer.notify_suspicious_sales_amount(vendor_phone.user).deliver
     Sms.push(vendor_phone, "Sorry your current Monthly Sales Amount its suspicious"); return
    end

    customer = user_code.user

    sender.interactions.create(name: "redeemed troca aki code", app_id: self.id)
    customer.interactions.create(name: "redeemed troca aki code", app_id: self.id)
    user_code.inc_usage

    Sms.push(vendor_phone, "Obrigado. Este codigo e valido, por favor entrega 1 garrafa de Certeza ao teu cliente e a PSI vai-te pagar os 10 meticais.")
    Sms.push(customer, "Parabens por trocares o codigo. Usa a garrafa de Certeza para teres agua limpa em casa e evitares as doencas diarreicas.")
  end 
end
