
Pod::Spec.new do |s|
  s.name             = 'popOverView'
  s.version          = '0.1.0'
  s.summary          = 'a popover view for easy use.'

  s.description      = 'no detail for description,you just to see more detail in demo'

  s.homepage         = 'https://github.com/zyggit/popOverView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zygmain@gmail.com' => 'zygmain@gmail.com' }
  s.source           = { :git => 'https://github.com/zyggit/popOverView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'popOverView/Classes/**/*'
end
