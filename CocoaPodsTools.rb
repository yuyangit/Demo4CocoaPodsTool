
require 'xcodeproj'
require 'plist'

if __FILE__ == $0
    project_path = $*[0]
    check_value = $*[1]
    puts project_path
    srcRootPath = File.dirname(project_path)
    project = Xcodeproj::Project.open(project_path)
    target = nil
    project.targets.each do |t|
        if t.product_type == "com.apple.product-type.application"
            target = t
        end
    end
    
    target.build_configurations.each do |conf|
        if conf.name == "Release"
            info_plist_path = conf.build_settings["INFOPLIST_FILE"].sub! "$(SRCROOT)", srcRootPath
            plist = Plist::parse_xml(info_plist_path)
            if plist["TYEnvironment"] != check_value
                abort "TYEnvironment匹配错误"
            end
        end
    end
end


