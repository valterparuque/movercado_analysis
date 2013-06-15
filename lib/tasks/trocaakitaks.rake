#Authour Valter Jerssen Paruque
#Email : valter.paruque@gmail.com
namespace :trocaAki do 
  desc "Task : Generate 1000 TrocaAki enters for same vendor"
  task :generateSales  => :environment do
    puts "begin task .... trocaAki:generateSales"

    # Retrive App TrocaAki
    t = TrocaAkiValidation.where(type: "TrocaAkiValidation").first_or_create

    # Grant that role Vendor exist
    Role.find_or_create_by_name("vendor")
    
    #Create a vendor
    vendor = User.create!    
    puts "Generating TrocaAki interections for Vendor with USER_ID = #{vendor.id}"

    #Set vendor role
    vendor.roles.create(app_id: t.id, name: "vendor")
    
    #Generate a UNIQUE Sender number here
    senderNumber = SecureRandom.hex
    vendor.phones.create(number:senderNumber)
     

    #Generate 1001 INTERECTIONS
  1001.times do  
      #Create differente custome
      customer = User.create!

      #Generate a new code for customer
      c = Code.create(app_id: t.id, user_id: customer.id)

      Sms.receive(
        senderNumber,
        "Movercado",
        c.to_s
      )

  end
    
    puts "End task.... trocaAki:generateSales"    
  end   
end

