class FeedbackMailer < ActionMailer::Base

  def send_feedback(params={})
  	message = params[:message] || '[no message entered]'
  	from = params[:from].present? ? params[:from] : '[anonymous]'
  	user_agent = params[:agent] || '[no user agent recorded]'

  	subject = '[ohanapi] '+from
  	body = message+'
----------------------------------------------------------------------------------
'+user_agent

    mail(to: 'anselm@codeforamerica.org,sophia@codeforamerica.org,moncef@codeforamerica.org', 
    	from: from, 
    	subject: subject, 
    	body: body)
  end
  
end