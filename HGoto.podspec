Pod::Spec.new do |s|

  s.name         = "HGoto"
  s.version      = "1.0.9"
  s.summary      = "A short description of HGoto."

  s.description  = <<-DESC
                   A longer description of HGoto in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://EXAMPLE/HGoto"
  
  s.author             = { "zct" => "zhangchutian@camera360.com" }

    s.source       = { :git => "https://github.com/jumperb/HGoto.git", :tag => s.version.to_s}

  s.source_files  = 'Classes/**/*.{h,m}'
  
  s.dependency 'Hodor/Feature'
  s.dependency 'Hodor/Defines'
  s.requires_arc = true
  
  s.ios.deployment_target = '7.0'
  
end
