Hash.class_eval do |h|
  alias_method(:to_report_json, :to_json)
end

Array.class_eval do |a|
  alias_method(:to_report_json, :to_json)
end

class ChartElement
  attr_accessor :internal_hash
  def initialize(&proc)
    @internal_hash = {}
    proc.call(self) if !proc.nil?
  end
  
  def method_missing(name, *args, &proc)    
    name = name.to_s
    # equals comes in on setter method names
    name.gsub!("=", "")
    # flash chart expects -...borrowed this from the rails plugin
    unders =
     %w(font_size dot_size outline_colour halo_size start_angle tick_height
       grid_colour tick_length no_labels label_colour gradient_fill fill_alpha
       on_click spoke_labels bg_colour)
    
    name.gsub!("_", "-") if !unders.index(name).nil?
    if args.size==0 and !proc.nil?
      @internal_hash[name] = ChartElement.new
      proc.call(@internal_hash[name])
    else
      @internal_hash[name] = *args
    end
  end

  def to_report_json(options = {})
    @internal_hash.to_report_json(options)
  end
end

module OpenFlashChart
  def self.chart_html(width, height, url, base="/")
    url = CGI::escape(url)
    # need something that will not be repeated on the same request
    special_hash = Base64.encode64(Digest::SHA1.digest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}/#{url}"))[0..7]
    # only good characters for our div
    special_hash = special_hash.gsub(/[^a-zA-Z0-9]/,rand(10).to_s)
    obj_id   = "chart_#{special_hash}"  # some sequencing without all the work of tracking it
    div_name = "flash_content_#{special_hash}"
    protocol = "http" # !request.nil? ? request.env["HTTPS"] || "http" : "http"

    # NOTE: users should put this in the <head> section themselves:
    ## <script type="text/javascript" src="#{base}/javascripts/swfobject.js"></script>

    <<-HTML
      <div id="#{div_name}"></div>
      <script type="text/javascript">
      swfobject.embedSWF("#{base}open-flash-chart.swf", "#{div_name}", 
                         "#{width}", "#{height}", "9.0.0", "expressInstall.swf",
                         {"data-file":"#{url}"}, {"wmode":"transparent"});
      </script>
      <noscript>
        <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                codebase="#{protocol}://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"
                width="#{width}" height="#{height}"
                id="#{obj_id}" align="middle" wmode="transparent">
          <param name="allowScriptAccess" value="sameDomain" />
          <param name="movie" value="#{base}open-flash-chart.swf?data=#{url}" />
          <param name="quality" value="high" />
          <param name="bgcolor" value="#FFFFFF" />
          <embed src="#{base}open-flash-chart.swf?data=#{url}" 
                 quality="high" bgcolor="#FFFFFF" width="#{width}"
                 height="#{height}" name="#{obj_id}" align="middle"
                 allowScriptAccess="sameDomain"
                 type="application/x-shockwave-flash"
                 pluginspage="#{protocol}://www.macromedia.com/go/getflashplayer"
                 id="#{obj_id}" />
        </object>
      </noscript>
    HTML
  end
end
