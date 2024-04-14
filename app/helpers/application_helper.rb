module ApplicationHelper
    def bootstrap_alert(key)
        case key
        when "success"
          "success"
        when "danger"
          "danger"
        when "notice"
          "success"
        end 
         end 
end
