
class ReportsController < ApplicationController
  GRAPH_SIZE=[700, 500]

  def stacked_bar_example
    respond_to do |wants|
      wants.html do
        if request.get?
          @graph = OpenFlashChart::chart_html(GRAPH_SIZE[0],
                                              GRAPH_SIZE[1],
                                              url_for(:action => "stacked_bar_example",
                                                      :format => :json ))
        end
      end
      wants.json do
        values = []
        (1..20).each do |order|
          values << [rand(200), rand(200)]
        end

        c = ChartElement.new
        c.title do |t|
          t.text  = "Stacked Bar Example"
        end

        c.elements = [
          ChartElement.new do |o|
            o.type   = "bar_stack"            
            o.values = values
            o.colours = ["#d01f3c", "#356aa0"]
            o.border = 2
            o.tip = '#val# of #total#'
            o.keys = [
              ChartElement.new{|x|x.font_size=13; 
                                  x.text="One Set";
                                  x.colour="#d01f3c"},
              ChartElement.new{|x|x.font_size=13; 
                                  x.text="Two Set";
                                  x.colour="#356aa0"},
            ]
          end
        ]

        labels = []
        (1..20).each do |one|
          labels << ChartElement.new do |e|
            e.size   = 15
            e.text   = "Label #{one}" 
            e.colour = "#0000ff"
          end
        end

        c.x_axis do |x|
          x.labels do |l|
            l.rotate = "vertical"
            l.labels = labels
          end
        end

        c.y_axis do |y|
          y.steps = 200
          y.max   = 2000
          y.min   = 0
        end

        render :text => c.to_json, :layout => false
      end
    end
  end
end
