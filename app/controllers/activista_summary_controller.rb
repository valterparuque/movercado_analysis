class ActivistaSummaryController < ApplicationController
  def index
  	#Get Week start date(Monday) from selected date
  	weekStartDate = ' interactions.created_at::date + (1 - extract(dow from interactions.created_at))::integer '
  	weekStartDateColumn = "week"

  	result = User.joins(:roles,:interactions)
  						.joins('INNER JOIN apps on apps.id = interactions.app_id')
  						.select("#{weekStartDate} as #{weekStartDateColumn} , users.id , count(*)")
						.where(:roles => {:name => 'activista'},:apps => {:type => 'IpcValidation'})
						.group("#{weekStartDate} , users.id")
						.order(" #{weekStartDate} asc, count(*) desc")

	# First we retrive unique week dates and then for each of dates with find top 10 users
	@activistasByWeek = Hash[result.uniq{|u| u.week}.map{|x| [x.week , result.where("#{weekStartDate}= '#{x.week}'").limit(10)]} ]
  end
end
