class MyFile
  def initialize(name)
    @name = name
    @owner = "root"
    @modes = 0
    # puts "#{self.class} - #{@name} created"
  end
  
  def owner(name)
    @owner = name
  end
  
  def modes(modes)
    @modes = modes
  end
  
  def to_s(prefix="")
    "#{prefix}#{@name} #{@owner} #{@modes}\n"
  end
end

class MyDirectory < MyFile
  def initialize(name, &block)
    super name
    @directories = []
    @files = []
    self.instance_eval(&block) if block
  end
  
  def directory(name, &block)
    dir = MyDirectory.new name
    @directories << dir
    dir.instance_eval(&block) if block
    dir
  end
  
  def file(name, &block)
    file = MyFile.new name
    @files << file
    file.instance_eval(&block) if block
    file
  end
  
  def to_s(prefix="")
    sub_prefix = "#{prefix} "
    s = "#{prefix}\\ #{@name}\n"
    @directories.each { |d| s << prefix << d.to_s(sub_prefix) } if @directories
    @files.each { |f| s << prefix << f.to_s(sub_prefix) } if @files
    s
  end
end

root = MyDirectory.new "root" do
  file "readme"

  directory "users" do
    owner root
    modes 744
    file "blah"
    file "moreblah"
  end
  directory "os"  
  directory "etc" do
    file "stuff"
    
    directory "init.d" do
      file "httpd" do
        owner "root" 
        modes "744"     
      end
    end
  end   
end

puts root.to_s