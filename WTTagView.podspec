Pod::Spec.new do |s|
  s.name             = "WTTagView"
  s.version          = "1.0"
  s.summary          = "A TagView used to add tags to an image. You can change tag directions, move tag position and delete tags. You can also custom tag styles."
  s.description      = <<-DESC
                        A TagView used to add tags to an image. You can change tag directions, move tag position and delete tags. You can also custom tag styles.
                        You use it like UITableView, Implementation the dataSouce and delegate methods. It also can be used in Interface Builder.
                       DESC
  s.homepage         = "https://github.com/wtlucky/WTTagView"
  s.screenshots      = "http://imgchr.com/images/tagViewEdit.gif", "http://imgchr.com/images/tagViewPreview.gif"
  s.license          = 'MIT'
  s.author           = { "wtlucky" => "wtlucky@foxmail.com" }
  s.source           = { :git => "https://github.com/wtlucky/WTTagView.git", :tag => "1.0" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*.{h,m}'
  s.resource_bundles = {
    'WTTagView' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Masonry', '~> 0.6.2'
end
