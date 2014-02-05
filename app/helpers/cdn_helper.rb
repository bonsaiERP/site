module CdnHelper
  SCRIPTS = {
    'jquery' => {
      klass: 'jQuery',
      cdn: 'http://code.jquery.com/jquery-2.1.0.min.js',
      local: '/assets/jquery/jquery-2.1.0.min.js'
    },
    'angular' => {
      klass: 'angular',
      cdn: 'https://ajax.googleapis.com/ajax/libs/angularjs/1.2.10/angular.min.js',
      local: '/assets/angular/angularjs.min.js'
    }
  }

  def bonsai_scripts(*args)
    inc = args.map do |src|
      content_tag(:script, nil, src: get_script(src))
    end.join("\n")

    [inc, bonsai_scripts_local(*args)].join("\n").html_safe
  end

  def bonsai_scripts_local(*args)
    html = '<script type="text/javascript">'
    args.each do |src|
      html << "\nif(typeof window.#{SCRIPTS[src][:klass]} ===  'undefined') { #{js_load_script src} }"
    end

    html << "\n</script>"
  end

  def js_load_script(src)
    "document.write(unescape(\"%3Cscript src='#{SCRIPTS[src][:local]}' type='text/javascript' %3E%3C/script%3E\"))"
  end

  def get_script(name)
    Rails.env.production? ? SCRIPTS.fetch(name)[:cdn] :  SCRIPTS.fetch(name)[:local]
  end
end
