class BrogramMailer < ActionMailer::Base
  default :from => "no-reply@zurb.com"

    def brogram(brogram)
      @brogram = brogram
      mail(:to => 'brogram@zurb.com', :subject => "Brogram | New brogram for #{brogram[:broname]}")
    end
end
