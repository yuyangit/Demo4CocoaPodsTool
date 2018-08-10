
require 'xcodeproj'
require 'plist'

if __FILE__ == $0
    project_path = $*[0]
    check_value = $*[1]
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
            info_plist_path = srcRootPath+"/"+conf.build_settings["INFOPLIST_FILE"]
            if conf.build_settings["INFOPLIST_FILE"].include?"$(SRCROOT)"
                info_plist_path = conf.build_settings["INFOPLIST_FILE"].sub! "$(SRCROOT)", srcRootPath
            end
            if File.exist?(info_plist_path)
                plist = Plist::parse_xml(info_plist_path)
                if plist["TYEnvironment"] && check_value
                    puts "TYEnvironment: {{plist['TYEnvironment']}}"
                    puts "输入的匹配值: {{ check_value }}"
                end
                if plist["TYEnvironment"] != check_value
                    if plist["TYEnvironment"] == nil
                        puts "TYEnvironment 不存在"
                        else
                        abort "TYEnvironment匹配错误"
                    end
                end
                else
                puts "Info.plist 不存在!!!"
            end
            
        end
    end
end


