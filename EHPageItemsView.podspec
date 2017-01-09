Pod::Spec.new do |s|
  s.name             = 'EHPageItemsView'
  s.version          = '1.0.0'
  s.summary          = 'a view which arranges same-size item views page by page.'

  s.description      = <<-DESC
EHPageItemsView: a view which arranges same-size item views page by page.
EHPageItemsSelectionView: selection version of EHPageItemsView, you can single-select or multiple-select
                       DESC

  s.homepage         = 'https://github.com/waterflowseast/EHPageItemsView'
  s.screenshots     = 'https://github.com/waterflowseast/EHPageItemsView/raw/master/screenshots/1.png', 'https://github.com/waterflowseast/EHPageItemsView/raw/master/screenshots/2.png', 'https://github.com/waterflowseast/EHPageItemsView/raw/master/screenshots/3.png', 'https://github.com/waterflowseast/EHPageItemsView/raw/master/screenshots/4.png', 'https://github.com/waterflowseast/EHPageItemsView/raw/master/screenshots/5.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Huang' => 'WaterFlowsEast@gmail.com' }
  s.source           = { :git => 'https://github.com/waterflowseast/EHPageItemsView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'EHPageItemsView/Classes/**/*'
  s.dependency 'EHItemViewCommon', '~> 1.0.0'
end
